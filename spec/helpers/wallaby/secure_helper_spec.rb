require 'rails_helper'

describe Wallaby::SecureHelper, clear: :object_space do
  describe '#user_portrait' do
    it 'returns a general user portrait image' do
      expect(helper.user_portrait(nil)).to eq '<i class="fa fa-user user-portrait"></i>'
      expect(helper.user_portrait(double)).to eq '<i class="fa fa-user user-portrait"></i>'
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
    it 'returns main app logout_path' do
      main_app = double logout_path: '/logout_path'
      hide_const 'Devise'
      expect(helper.logout_path(nil, main_app)).to eq '/logout_path'
    end

    context 'when it has devise scope' do
      it 'returns devise path' do
        main_app = double destroy_user_session_path: '/destroy_user_session_path'
        stub_const('Devise::Mapping', Class.new do
          def self.find_scope!(_user); 'user'; end
        end)
        expect(helper.logout_path(nil, main_app)).to eq '/destroy_user_session_path'
      end
    end
  end

  describe '#logout_method' do
    it 'returns delete' do
      hide_const 'Devise'
      expect(helper.logout_method).to eq :delete
    end

    context 'when Devise exists' do
      it 'returns Devise preferred method' do
        stub_const('Devise', Class.new do
          def self.sign_out_via; :put; end
        end)
        expect(helper.logout_method).to eq :put
      end
    end
  end
end
