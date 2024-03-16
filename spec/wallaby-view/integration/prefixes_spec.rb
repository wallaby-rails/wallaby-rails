# frozen_string_literal: true

require 'rails_helper'

describe 'prefixes', type: :request do
  context 'with backend application prefixes' do
    specify do
      http(:get, backend_prefixes_path)

      expect(response).to be_successful
      expect(page_json).to eq([
        'backend/application/prefixes',
        'backend/application',
        'secure/prefixes',
        'secure',
        'application/prefixes',
        'application'
      ])
    end
  end

  context 'with backend users prefixes' do
    specify do
      http(:get, prefixes_backend_user_path)

      expect(response).to be_successful
      expect(page_json).to eq([
        'backend/users/prefixes',
        'backend/users',
        'account/prefixes',
        'account',
        'backend/application/prefixes',
        'backend/application',
        'secure/prefixes',
        'secure',
        'application/prefixes',
        'application'
      ])
    end
  end

  context 'with backend user profiles prefixes' do
    specify do
      http(:get, prefixes_backend_user_profile_path)

      expect(response).to be_successful
      expect(page_json).to eq([
        'backend/user_profiles/prefixes',
        'backend/user_profiles',
        'backend/users/prefixes',
        'backend/users',
        'account/prefixes',
        'account',
        'backend/application/prefixes',
        'backend/application',
        'secure/prefixes',
        'secure',
        'application/prefixes',
        'application'
      ])
    end
  end

  context 'with backend custom' do
    specify do
      http(:get, prefixes_backend_custom_path)

      expect(response).to be_successful
      expect(page_json).to eq([
        'super/man/prefixes',
        'super/man/form',
        'super/man',
        'backend/customs/prefixes',
        'backend/customs/form',
        'backend/customs',
        'backend/users/prefixes',
        'backend/users/form',
        'backend/users',
        'account/prefixes',
        'account/form',
        'account',
        'backend/application/prefixes',
        'backend/application/form',
        'backend/application',
        'secure/prefixes',
        'secure/form',
        'secure',
        'application/prefixes',
        'application/form',
        'application'
      ])
    end
  end

  context 'with backend custom child' do
    specify do
      http(:get, prefixes_backend_custom_child_path)

      expect(response).to be_successful
      expect(page_json).to eq([
        'backend/custom_children/prefixes',
        'backend/custom_children/form',
        'backend/custom_children',
        'super/man/prefixes',
        'super/man/form',
        'super/man',
        'backend/customs/prefixes',
        'backend/customs/form',
        'backend/customs',
        'backend/users/prefixes',
        'backend/users/form',
        'backend/users',
        'account/prefixes',
        'account/form',
        'account',
        'backend/application/prefixes',
        'backend/application/form',
        'backend/application',
        'secure/prefixes',
        'secure/form',
        'secure',
        'application/prefixes',
        'application/form',
        'application'
      ])
    end
  end

  context 'with backend user profiles show and its partial' do
    specify do
      http(:get, backend_user_profile_path)

      expect(response).to be_successful
      assert_select 'h4', 100
    end
  end
end
