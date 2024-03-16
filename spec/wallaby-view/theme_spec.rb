# frozen_string_literal: true

require 'rails_helper'

describe 'theme' do
  context 'with Backend::ApplicationController' do
    specify do
      expect(Backend::ApplicationController.theme_name).to eq('secure')
      expect(Backend::ApplicationController._layout).to eq('secure')
      expect(Backend::ApplicationController.theme).to eq(theme_name: 'secure', theme_path: 'backend/application')
      expect(Backend::ApplicationController.themes).to eq([{ theme_name: 'secure', theme_path: 'backend/application' }])
    end
  end

  context 'with Backend::UsersController' do
    specify do
      expect(Backend::UsersController.theme_name).to eq('account')
      expect(Backend::UsersController._layout).to eq('account')
      expect(Backend::UsersController.theme).to eq(theme_name: 'account', theme_path: 'backend/users')
      expect(Backend::UsersController.themes).to eq([{ theme_name: 'account', theme_path: 'backend/users' }, { theme_name: 'secure', theme_path: 'backend/application' }])
    end
  end

  context 'with Backend::UserProfilesController' do
    specify do
      expect(Backend::UserProfilesController.theme_name).to eq('account')
      expect(Backend::UserProfilesController._layout).to eq('account')
      expect(Backend::UserProfilesController.theme).to eq(theme_name: 'account', theme_path: 'backend/users')
      expect(Backend::UserProfilesController.themes).to eq([{ theme_name: 'account', theme_path: 'backend/users' }, { theme_name: 'secure', theme_path: 'backend/application' }])
    end
  end

  context 'with CollectionsController' do
    specify do
      expect(CollectionsController.theme_name).to be_nil
      expect(CollectionsController._layout).to be_nil
      expect(CollectionsController.theme).to be_nil
      expect(CollectionsController.themes).to eq([])
    end

    context 'when theme_name is set to not true' do
      specify do
        CollectionsController.theme_name = false
        expect(CollectionsController.theme_name).to be_nil
        expect(CollectionsController._layout).to eq(false)
        expect(CollectionsController.theme).to be_nil
        expect(CollectionsController.themes).to eq([])

        CollectionsController.theme_name = nil
        expect(CollectionsController.theme_name).to be_nil
        expect(CollectionsController._layout).to be_nil
      end
    end

    context 'when theme_name is set to string and nil' do
      specify do
        CollectionsController.theme_name = 'test'
        expect(CollectionsController.theme_name).to eq('test')
        expect(CollectionsController._layout).to eq('test')
        expect(CollectionsController.theme).to eq(theme_name: 'test', theme_path: 'collections')
        expect(CollectionsController.themes).to eq([{ theme_name: 'test', theme_path: 'collections' }])

        CollectionsController.theme_name = nil
        expect(CollectionsController.theme_name).to be_nil
        expect(CollectionsController._layout).to be_nil
      end
    end
  end
end
