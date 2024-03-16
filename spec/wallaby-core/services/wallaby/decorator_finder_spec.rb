# frozen_string_literal: true

require 'rails_helper'

describe Wallaby::DecoratorFinder do
  describe '#execute' do
    subject { described_class.new(script_name: script_name, model_class: model_class, current_controller_class: current_controller_class).execute }

    let(:script_name) { '/admin' }
    let(:model_class) { User }
    let(:current_controller_class) { admin_application_controller }

    let!(:admin_application_controller) { Wallaby::ResourcesController }
    let!(:admin_application_decorator) { Wallaby::ResourceDecorator }
    let!(:user) { stub_const('User', Class.new) }
    let!(:users_controller) do
      stub_const(
        'UsersController',
        Class.new(::ApplicationController) do
          include Wallaby::ResourcesConcern
        end
      )
    end

    it { is_expected.to eq Wallaby::ResourceDecorator }

    context 'when admin application controller exists' do
      let!(:admin_application_controller) { stub_const('Admin::ApplicationController', base_class_from(Wallaby::ResourcesController)) }

      it { is_expected.to eq Wallaby::ResourceDecorator }

      context 'when admin application decorator exists' do
        let!(:admin_application_decorator) { stub_const('Admin::ApplicationDecorator', base_class_from(Wallaby::ResourceDecorator)) }

        it { is_expected.to eq Admin::ApplicationDecorator }
      end
    end

    context 'when admin users controller exists (admin interface)' do
      let!(:admin_products_controller) { stub_const('Admin::ProductsController', Class.new(admin_application_controller)) }
      let!(:admin_users_controller) { stub_const('Admin::UsersController', Class.new(admin_application_controller)) }
      let!(:admin_custom_users_controller) { stub_const('Admin::Custom::UsersController', Class.new(admin_application_controller)) }

      it { is_expected.to eq Wallaby::ResourceDecorator }

      context 'when current controller is admin users controller' do
        let(:current_controller_class) { admin_users_controller }

        it { is_expected.to eq Wallaby::ResourceDecorator }
      end

      context 'when current controller is admin products controller' do
        let(:current_controller_class) { admin_products_controller }

        it { is_expected.to eq Wallaby::ResourceDecorator }
      end

      context 'when current controller is admin custom users controller' do
        let(:current_controller_class) { admin_custom_users_controller }

        it { is_expected.to eq Wallaby::ResourceDecorator }

        context 'when custom decorator exists' do
          let!(:admin_custom_user_decorator) { stub_const('Admin::Custom::UserDecorator', Class.new(admin_application_decorator)) }

          it { is_expected.to eq Admin::Custom::UserDecorator }
        end
      end

      context 'when admin application controller exists' do
        let!(:admin_application_controller) { stub_const('Admin::ApplicationController', base_class_from(Wallaby::ResourcesController)) }

        it { is_expected.to eq Wallaby::ResourceDecorator }

        context 'when current controller is admin users controller' do
          let(:current_controller_class) { admin_users_controller }

          it { is_expected.to eq Wallaby::ResourceDecorator }
        end

        context 'when current controller is admin products controller' do
          let(:current_controller_class) { admin_products_controller }

          it { is_expected.to eq Wallaby::ResourceDecorator }
        end

        context 'when current controller is admin custom users controller' do
          let(:current_controller_class) { admin_custom_users_controller }

          it { is_expected.to eq Wallaby::ResourceDecorator }

          context 'when custom decorator exists' do
            let!(:admin_custom_user_decorator) { stub_const('Admin::Custom::UserDecorator', Class.new(admin_application_decorator)) }

            it { is_expected.to eq Admin::Custom::UserDecorator }
          end
        end

        context 'when admin application decorator exists' do
          let!(:admin_application_decorator) { stub_const('Admin::ApplicationDecorator', base_class_from(Wallaby::ResourceDecorator)) }

          it { is_expected.to eq Admin::ApplicationDecorator }

          context 'when current controller is admin users controller' do
            let(:current_controller_class) { admin_users_controller }

            it { is_expected.to eq Admin::ApplicationDecorator }
          end

          context 'when current controller is admin products controller' do
            let(:current_controller_class) { admin_products_controller }

            it { is_expected.to eq Admin::ApplicationDecorator }
          end

          context 'when current controller is admin custom users controller' do
            let(:current_controller_class) { admin_custom_users_controller }

            it { is_expected.to eq Admin::ApplicationDecorator }

            context 'when custom decorator exists' do
              let!(:admin_custom_user_decorator) { stub_const('Admin::Custom::UserDecorator', Class.new(admin_application_decorator)) }

              it { is_expected.to eq Admin::Custom::UserDecorator }
            end
          end

          context 'when admin User decorator exists' do
            let!(:admin_user_decorator) { stub_const('Admin::UserDecorator', base_class_from(admin_application_decorator)) }

            it { is_expected.to eq Admin::UserDecorator }

            context 'when current controller is admin users controller' do
              let(:current_controller_class) { admin_users_controller }

              it { is_expected.to eq Admin::UserDecorator }
            end

            context 'when current controller is admin products controller' do
              let(:current_controller_class) { admin_products_controller }

              it { is_expected.to eq Admin::UserDecorator }
            end

            context 'when current controller is admin custom users controller' do
              let(:current_controller_class) { admin_custom_users_controller }

              it { is_expected.to eq Admin::UserDecorator }

              context 'when custom decorator exists' do
                let!(:admin_custom_user_decorator) { stub_const('Admin::Custom::UserDecorator', Class.new(admin_application_decorator)) }

                it { is_expected.to eq Admin::Custom::UserDecorator }
              end
            end
          end
        end
      end
    end

    context 'when script name is blank (general usage)' do
      let(:script_name) { '' }
      let(:current_controller_class) { users_controller }
      let(:admin_application_decorator) { Wallaby::ResourceDecorator }

      it { is_expected.to eq Wallaby::ResourceDecorator }

      context 'when user decorator exists' do
        let!(:user_decorator) { stub_const('UserDecorator', base_class_from(admin_application_decorator)) }
        let!(:admin_user_decorator) { stub_const('Admin::UserDecorator', base_class_from(admin_application_decorator)) }

        it { is_expected.to eq UserDecorator }
      end
    end
  end
end
