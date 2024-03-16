# frozen_string_literal: true

require 'rails_helper'

describe Wallaby::SecureHelper, type: :helper do
  describe '#user_portrait' do
    it 'returns a general user portrait image' do
      expect(helper.user_portrait(user: nil)).to include '<i class="fa fa-user'
      expect(helper.user_portrait(user: instance_double('instance'))).to include '<i class="fa fa-user'
    end

    context 'when email_method is configured' do
      it 'returns user gravatar' do
        helper.wallaby_controller.email_method = 'email_address'
        user = instance_double 'user', email_address: 'tian@example.com'
        expect(helper.user_portrait(user: user)).to match(/<img /)
        expect(helper.user_portrait(user: user)).to match(%r{www.gravatar.com/avatar/})

        version_specific = {
          '>= 5.2' => '<img class="user" src="http://www.gravatar.com/avatar/4f6994f5bafb573ca145d9e62e5fdfae" />'
        }
        expected = minor version_specific, '<img class="user" src="http://www.gravatar.com/avatar/4f6994f5bafb573ca145d9e62e5fdfae" alt="4f6994f5bafb573ca145d9e62e5fdfae" />'
        expect(helper.user_portrait(user: user)).to eq expected
      end
    end

    context 'when user object respond_to email' do
      it 'returns user gravatar' do
        user = instance_double 'user', email: 'tian@example.com'
        expect(helper.user_portrait(user: user)).to match(/<img /)
        expect(helper.user_portrait(user: user)).to match(%r{www.gravatar.com/avatar/})

        version_specific = {
          '>= 5.2' => '<img class="user" src="http://www.gravatar.com/avatar/4f6994f5bafb573ca145d9e62e5fdfae" />'
        }
        expected = minor version_specific, '<img class="user" src="http://www.gravatar.com/avatar/4f6994f5bafb573ca145d9e62e5fdfae" alt="4f6994f5bafb573ca145d9e62e5fdfae" />'
        expect(helper.user_portrait(user: user)).to eq expected
      end
    end
  end

  describe '#logout_path' do
    it 'returns nothing' do
      hide_const 'Devise'
      expect(helper.logout_path(user: nil, app: nil)).to be_nil
    end

    context 'when logout_path is configured' do
      it 'returns logout_path' do
        helper.wallaby_controller.logout_path = 'logout_path'
        main_app = instance_double 'app', logout_path: '/logout_path'
        hide_const 'Devise'
        expect(helper.logout_path(user: nil, app: main_app)).to eq '/logout_path'
      end
    end

    context 'when it has devise scope' do
      it 'returns devise path' do
        stub_const('ManagementUser', Class.new)
        Devise.add_mapping(:management_user, {})
        main_app = instance_double 'app', destroy_management_user_session_path: '/destroy_management_user_session_path'
        expect(helper.logout_path(user: ManagementUser.new, app: main_app)).to eq '/destroy_management_user_session_path'
        Devise.mappings.clear
      end
    end
  end

  describe '#logout_method' do
    it 'returns delete' do
      hide_const 'Devise'
      expect(helper.logout_method(user: nil)).to be_nil
    end

    context 'when logout_method is configured' do
      it 'returns logout_method' do
        helper.wallaby_controller.logout_method = 'put'
        hide_const 'Devise'
        expect(helper.logout_method(user: nil)).to eq 'put'
      end
    end

    context 'when Devise exists' do
      it 'returns Devise preferred method' do
        stub_const('SuperUser', Class.new)
        Devise.add_mapping(:super_user, {})
        expect(helper.logout_method(user: SuperUser.new)).to eq :delete
        Devise.mappings.clear
      end
    end
  end
end
