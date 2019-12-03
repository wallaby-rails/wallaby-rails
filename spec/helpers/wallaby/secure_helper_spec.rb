require 'rails_helper'

describe Wallaby::SecureHelper do
  describe '#user_portrait' do
    it 'returns a general user portrait image' do
      expect(helper.user_portrait(nil)).to include '<i class="fa fa-user'
      expect(helper.user_portrait(instance_double('instance'))).to include '<i class="fa fa-user'
    end

    context 'when email_method is configured' do
      it 'returns user gravatar ' do
        Wallaby.configuration.security.email_method = 'email_address'
        user = instance_double 'user', email_address: 'tian@example.com'
        expect(helper.user_portrait(user)).to match(/<img /)
        expect(helper.user_portrait(user)).to match(%r{www.gravatar.com/avatar/})

        version_specific = {
          '>= 5.2' => '<img class="user" src="http://www.gravatar.com/avatar/4f6994f5bafb573ca145d9e62e5fdfae" />'
        }
        expected = minor version_specific, '<img class="user" src="http://www.gravatar.com/avatar/4f6994f5bafb573ca145d9e62e5fdfae" alt="4f6994f5bafb573ca145d9e62e5fdfae" />'
        expect(helper.user_portrait(user)).to eq expected
      end
    end

    context 'when user object respond_to email' do
      it 'returns user gravatar ' do
        user = instance_double 'user', email: 'tian@example.com'
        expect(helper.user_portrait(user)).to match(/<img /)
        expect(helper.user_portrait(user)).to match(%r{www.gravatar.com/avatar/})

        version_specific = {
          '>= 5.2' => '<img class="user" src="http://www.gravatar.com/avatar/4f6994f5bafb573ca145d9e62e5fdfae" />'
        }
        expected = minor version_specific, '<img class="user" src="http://www.gravatar.com/avatar/4f6994f5bafb573ca145d9e62e5fdfae" alt="4f6994f5bafb573ca145d9e62e5fdfae" />'
        expect(helper.user_portrait(user)).to eq expected
      end
    end
  end

  describe '#logout_path' do
    it 'returns nothing' do
      hide_const 'Devise'
      expect(helper.logout_path(nil, nil)).to be_nil
    end

    context 'when logout_path is configured' do
      it 'returns logout_path' do
        Wallaby.configuration.security.logout_path = 'logout_path'
        main_app = instance_double 'app', logout_path: '/logout_path'
        hide_const 'Devise'
        expect(helper.logout_path(nil, main_app)).to eq '/logout_path'
      end
    end

    context 'when it has devise scope' do
      it 'returns devise path' do
        stub_const('ManagementUser', Class.new)
        Devise.add_mapping(:management_user, {})
        main_app = instance_double 'app', destroy_management_user_session_path: '/destroy_management_user_session_path'
        expect(helper.logout_path(ManagementUser.new, main_app)).to eq '/destroy_management_user_session_path'
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
        stub_const('SuperUser', Class.new)
        Devise.add_mapping(:super_user, {})
        expect(helper.logout_method(SuperUser.new)).to eq :delete
        Devise.mappings.clear
      end
    end
  end
end
