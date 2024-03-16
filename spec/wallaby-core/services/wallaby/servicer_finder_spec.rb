# frozen_string_literal: true

require 'rails_helper'

describe Wallaby::ServicerFinder do
  describe '#execute' do
    subject { described_class.new(script_name: script_name, model_class: model_class, current_controller_class: current_controller_class).execute }

    let(:script_name) { '/admin' }
    let(:model_class) { User }
    let(:current_controller_class) { admin_application_controller }

    let!(:admin_application_controller) { Wallaby::ResourcesController }
    let!(:admin_application_servicer) { Wallaby::ModelServicer }
    let!(:user) { stub_const('User', Class.new) }
    let!(:users_controller) do
      stub_const(
        'UsersController',
        Class.new(::ApplicationController) do
          include Wallaby::ResourcesConcern
        end
      )
    end

    it { is_expected.to eq Wallaby::ModelServicer }

    context 'when admin application controller exists' do
      let!(:admin_application_controller) { stub_const('Admin::ApplicationController', base_class_from(Wallaby::ResourcesController)) }

      it { is_expected.to eq Wallaby::ModelServicer }

      context 'when admin application servicer exists' do
        let!(:admin_application_servicer) { stub_const('Admin::ApplicationServicer', base_class_from(Wallaby::ModelServicer)) }

        it { is_expected.to eq Admin::ApplicationServicer }
      end
    end

    context 'when admin users controller exists (admin interface)' do
      let!(:admin_products_controller) { stub_const('Admin::ProductsController', Class.new(admin_application_controller)) }
      let!(:admin_users_controller) { stub_const('Admin::UsersController', Class.new(admin_application_controller)) }
      let!(:admin_custom_users_controller) { stub_const('Admin::Custom::UsersController', Class.new(admin_application_controller)) }

      it { is_expected.to eq Wallaby::ModelServicer }

      context 'when current controller is admin users controller' do
        let(:current_controller_class) { admin_users_controller }

        it { is_expected.to eq Wallaby::ModelServicer }
      end

      context 'when current controller is admin products controller' do
        let(:current_controller_class) { admin_products_controller }

        it { is_expected.to eq Wallaby::ModelServicer }
      end

      context 'when current controller is admin custom users controller' do
        let(:current_controller_class) { admin_custom_users_controller }

        it { is_expected.to eq Wallaby::ModelServicer }

        context 'when custom servicer exists' do
          let!(:admin_custom_user_servicer) { stub_const('Admin::Custom::UserServicer', Class.new(admin_application_servicer)) }

          it { is_expected.to eq Admin::Custom::UserServicer }
        end
      end

      context 'when admin application controller exists' do
        let!(:admin_application_controller) { stub_const('Admin::ApplicationController', base_class_from(Wallaby::ResourcesController)) }

        it { is_expected.to eq Wallaby::ModelServicer }

        context 'when current controller is admin users controller' do
          let(:current_controller_class) { admin_users_controller }

          it { is_expected.to eq Wallaby::ModelServicer }
        end

        context 'when current controller is admin products controller' do
          let(:current_controller_class) { admin_products_controller }

          it { is_expected.to eq Wallaby::ModelServicer }
        end

        context 'when current controller is admin custom users controller' do
          let(:current_controller_class) { admin_custom_users_controller }

          it { is_expected.to eq Wallaby::ModelServicer }

          context 'when custom servicer exists' do
            let!(:admin_custom_user_servicer) { stub_const('Admin::Custom::UserServicer', Class.new(admin_application_servicer)) }

            it { is_expected.to eq Admin::Custom::UserServicer }
          end
        end

        context 'when admin application servicer exists' do
          let!(:admin_application_servicer) { stub_const('Admin::ApplicationServicer', base_class_from(Wallaby::ModelServicer)) }

          it { is_expected.to eq Admin::ApplicationServicer }

          context 'when current controller is admin users controller' do
            let(:current_controller_class) { admin_users_controller }

            it { is_expected.to eq Admin::ApplicationServicer }
          end

          context 'when current controller is admin products controller' do
            let(:current_controller_class) { admin_products_controller }

            it { is_expected.to eq Admin::ApplicationServicer }
          end

          context 'when current controller is admin custom users controller' do
            let(:current_controller_class) { admin_custom_users_controller }

            it { is_expected.to eq Admin::ApplicationServicer }

            context 'when custom servicer exists' do
              let!(:admin_custom_user_servicer) { stub_const('Admin::Custom::UserServicer', Class.new(admin_application_servicer)) }

              it { is_expected.to eq Admin::Custom::UserServicer }
            end
          end

          context 'when admin User servicer exists' do
            let!(:admin_user_servicer) { stub_const('Admin::UserServicer', base_class_from(admin_application_servicer)) }

            it { is_expected.to eq Admin::UserServicer }

            context 'when current controller is admin users controller' do
              let(:current_controller_class) { admin_users_controller }

              it { is_expected.to eq Admin::UserServicer }
            end

            context 'when current controller is admin products controller' do
              let(:current_controller_class) { admin_products_controller }

              it { is_expected.to eq Admin::UserServicer }
            end

            context 'when current controller is admin custom users controller' do
              let(:current_controller_class) { admin_custom_users_controller }

              it { is_expected.to eq Admin::UserServicer }

              context 'when custom servicer exists' do
                let!(:admin_custom_user_servicer) { stub_const('Admin::Custom::UserServicer', Class.new(admin_application_servicer)) }

                it { is_expected.to eq Admin::Custom::UserServicer }
              end
            end
          end
        end
      end
    end

    context 'when script name is blank (general usage)' do
      let(:script_name) { '' }
      let(:current_controller_class) { users_controller }
      let(:admin_application_servicer) { Wallaby::ModelServicer }

      it { is_expected.to eq Wallaby::ModelServicer }

      context 'when user servicer exists' do
        let!(:user_servicer) { stub_const('UserServicer', base_class_from(admin_application_servicer)) }
        let!(:admin_user_servicer) { stub_const('Admin::UserServicer', base_class_from(admin_application_servicer)) }

        it { is_expected.to eq UserServicer }
      end
    end
  end
end
