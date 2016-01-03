require 'rails_helper'

describe Wallaby::SecureHelper do
  describe '#user_portrait' do
    it 'returns a general user portrait image' do
      expect(helper.user_portrait nil).to match %r(<i )
    end

    context 'user object respond_to email' do
      it 'returns user gravatar ' do
        user = double email: 'tian@example.com'
        expect(helper.user_portrait user).to match %r(<img )
        expect(helper.user_portrait user).to match %r(www.gravatar.com/avatar/)
      end
    end
  end

  describe '#logout_path' do
    before do
      allow(main_app).to receive(:logout_path).and_return('/logout_path')
    end

    it 'returns main app logout_path' do
      hide_const 'Devise'
      expect(helper.logout_path).to eq '/logout_path'
    end

    context 'when it has devise scope' do
      before do
        allow(main_app).to receive(:destroy_user_session_path).and_return('/destroy_user_session_path')
        allow(helper).to receive :current_user
      end

      it 'returns devise path' do
        stub_const('Devise::Mapping', Class.new do
          def self.find_scope!(user); 'user'; end
        end)
        expect(helper.logout_path).to eq '/destroy_user_session_path'
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