require 'rails_helper'

describe Wallaby::SecureHelper, clear: :object_space do
  describe '#user_portrait' do
    it 'returns a general user portrait image' do
      expect(helper.user_portrait(nil)).to eq '<i class="fa fa-user user-portrait"></i>'
      expect(helper.user_portrait(double)).to eq '<i class="fa fa-user user-portrait"></i>'
    end

    context 'when email_method is configured' do
      it 'returns user gravatar ' do
        Wallaby.configuration.security.email_method = 'email_address'
        user = double email_address: 'tian@example.com'
        expect(helper.user_portrait(user)).to match(/<img /)
        expect(helper.user_portrait(user)).to match(%r{www.gravatar.com/avatar/})

        version_specific = {
          5 => {
            2 => '<img class="hidden-xs user-portrait" src="http://www.gravatar.com/avatar/4f6994f5bafb573ca145d9e62e5fdfae" />'
          }
        }
        expected = minor version_specific, '<img class="hidden-xs user-portrait" src="http://www.gravatar.com/avatar/4f6994f5bafb573ca145d9e62e5fdfae" alt="4f6994f5bafb573ca145d9e62e5fdfae" />'
        expect(helper.user_portrait(user)).to eq expected
      end
    end

    context 'user object respond_to email' do
      it 'returns user gravatar ' do
        user = double email: 'tian@example.com'
        expect(helper.user_portrait(user)).to match(/<img /)
        expect(helper.user_portrait(user)).to match(%r{www.gravatar.com/avatar/})

        version_specific = {
          5 => {
            2 => '<img class="hidden-xs user-portrait" src="http://www.gravatar.com/avatar/4f6994f5bafb573ca145d9e62e5fdfae" />'
          }
        }
        expected = minor version_specific, '<img class="hidden-xs user-portrait" src="http://www.gravatar.com/avatar/4f6994f5bafb573ca145d9e62e5fdfae" alt="4f6994f5bafb573ca145d9e62e5fdfae" />'
        expect(helper.user_portrait(user)).to eq expected
      end
    end
  end

  describe '#logout_path' do
    it 'returns nothing' do
      hide_const 'Devise'
      expect(helper.logout_path(nil, main_app)).to be_nil
    end

    context 'when logout_path is configured' do
      it 'returns logout_path' do
        Wallaby.configuration.security.logout_path = 'logout_path'
        main_app = double logout_path: '/logout_path'
        hide_const 'Devise'
        expect(helper.logout_path(nil, main_app)).to eq '/logout_path'
      end
    end

    context 'when it has devise scope' do
      it 'returns devise path' do
        stub_const('User', Class.new)
        Devise.add_mapping(:user, {})
        main_app = double destroy_user_session_path: '/destroy_user_session_path'
        expect(helper.logout_path(User.new, main_app)).to eq '/destroy_user_session_path'
        ActiveSupport::Dependencies.clear
        Devise.mappings.clear
      end
    end
  end

  describe '#logout_method' do
    it 'returns delete' do
      hide_const 'Devise'
      expect(helper.logout_method(nil)).to be_nil
    end

    context 'when logout_method is configured' do
      it 'returns logout_method' do
        Wallaby.configuration.security.logout_method = 'put'
        hide_const 'Devise'
        expect(helper.logout_method(nil)).to eq 'put'
      end
    end

    context 'when Devise exists' do
      it 'returns Devise preferred method' do
        stub_const('User', Class.new)
        Devise.add_mapping(:user, {})
        expect(helper.logout_method(User.new)).to eq :delete
        ActiveSupport::Dependencies.clear
        Devise.mappings.clear
      end
    end
  end
end
