# frozen_string_literal: true

require 'rails_helper'

describe Wallaby::PaginatorFinder do
  describe '#execute' do
    subject { described_class.new(script_name: script_name, model_class: model_class, current_controller_class: current_controller_class).execute }

    let(:script_name) { '/admin' }
    let(:model_class) { User }
    let(:current_controller_class) { admin_application_controller }

    let!(:admin_application_controller) { Wallaby::ResourcesController }
    let!(:admin_application_paginator) { Wallaby::ModelPaginator }
    let!(:user) { stub_const('User', Class.new) }
    let!(:users_controller) do
      stub_const(
        'UsersController',
        Class.new(::ApplicationController) do
          include Wallaby::ResourcesConcern
        end
      )
    end

    it { is_expected.to eq Wallaby::ModelPaginator }

    context 'when admin application controller exists' do
      let!(:admin_application_controller) { stub_const('Admin::ApplicationController', base_class_from(Wallaby::ResourcesController)) }

      it { is_expected.to eq Wallaby::ModelPaginator }

      context 'when admin application paginator exists' do
        let!(:admin_application_paginator) { stub_const('Admin::ApplicationPaginator', base_class_from(Wallaby::ModelPaginator)) }

        it { is_expected.to eq Admin::ApplicationPaginator }
      end
    end

    context 'when admin users controller exists (admin interface)' do
      let!(:admin_products_controller) { stub_const('Admin::ProductsController', Class.new(admin_application_controller)) }
      let!(:admin_users_controller) { stub_const('Admin::UsersController', Class.new(admin_application_controller)) }
      let!(:admin_custom_users_controller) { stub_const('Admin::Custom::UsersController', Class.new(admin_application_controller)) }

      it { is_expected.to eq Wallaby::ModelPaginator }

      context 'when current controller is admin users controller' do
        let(:current_controller_class) { admin_users_controller }

        it { is_expected.to eq Wallaby::ModelPaginator }
      end

      context 'when current controller is admin products controller' do
        let(:current_controller_class) { admin_products_controller }

        it { is_expected.to eq Wallaby::ModelPaginator }
      end

      context 'when current controller is admin custom users controller' do
        let(:current_controller_class) { admin_custom_users_controller }

        it { is_expected.to eq Wallaby::ModelPaginator }

        context 'when custom paginator exists' do
          let!(:admin_custom_user_paginator) { stub_const('Admin::Custom::UserPaginator', Class.new(admin_application_paginator)) }

          it { is_expected.to eq Admin::Custom::UserPaginator }
        end
      end

      context 'when admin application controller exists' do
        let!(:admin_application_controller) { stub_const('Admin::ApplicationController', base_class_from(Wallaby::ResourcesController)) }

        it { is_expected.to eq Wallaby::ModelPaginator }

        context 'when current controller is admin users controller' do
          let(:current_controller_class) { admin_users_controller }

          it { is_expected.to eq Wallaby::ModelPaginator }
        end

        context 'when current controller is admin products controller' do
          let(:current_controller_class) { admin_products_controller }

          it { is_expected.to eq Wallaby::ModelPaginator }
        end

        context 'when current controller is admin custom users controller' do
          let(:current_controller_class) { admin_custom_users_controller }

          it { is_expected.to eq Wallaby::ModelPaginator }

          context 'when custom paginator exists' do
            let!(:admin_custom_user_paginator) { stub_const('Admin::Custom::UserPaginator', Class.new(admin_application_paginator)) }

            it { is_expected.to eq Admin::Custom::UserPaginator }
          end
        end

        context 'when admin application paginator exists' do
          let!(:admin_application_paginator) { stub_const('Admin::ApplicationPaginator', base_class_from(Wallaby::ModelPaginator)) }

          it { is_expected.to eq Admin::ApplicationPaginator }

          context 'when current controller is admin users controller' do
            let(:current_controller_class) { admin_users_controller }

            it { is_expected.to eq Admin::ApplicationPaginator }
          end

          context 'when current controller is admin products controller' do
            let(:current_controller_class) { admin_products_controller }

            it { is_expected.to eq Admin::ApplicationPaginator }
          end

          context 'when current controller is admin custom users controller' do
            let(:current_controller_class) { admin_custom_users_controller }

            it { is_expected.to eq Admin::ApplicationPaginator }

            context 'when custom paginator exists' do
              let!(:admin_custom_user_paginator) { stub_const('Admin::Custom::UserPaginator', Class.new(admin_application_paginator)) }

              it { is_expected.to eq Admin::Custom::UserPaginator }
            end
          end

          context 'when admin User paginator exists' do
            let!(:admin_user_paginator) { stub_const('Admin::UserPaginator', base_class_from(admin_application_paginator)) }

            it { is_expected.to eq Admin::UserPaginator }

            context 'when current controller is admin users controller' do
              let(:current_controller_class) { admin_users_controller }

              it { is_expected.to eq Admin::UserPaginator }
            end

            context 'when current controller is admin products controller' do
              let(:current_controller_class) { admin_products_controller }

              it { is_expected.to eq Admin::UserPaginator }
            end

            context 'when current controller is admin custom users controller' do
              let(:current_controller_class) { admin_custom_users_controller }

              it { is_expected.to eq Admin::UserPaginator }

              context 'when custom paginator exists' do
                let!(:admin_custom_user_paginator) { stub_const('Admin::Custom::UserPaginator', Class.new(admin_application_paginator)) }

                it { is_expected.to eq Admin::Custom::UserPaginator }
              end
            end
          end
        end
      end
    end

    context 'when script name is blank (general usage)' do
      let(:script_name) { '' }
      let(:current_controller_class) { users_controller }
      let(:admin_application_paginator) { Wallaby::ModelPaginator }

      it { is_expected.to eq Wallaby::ModelPaginator }

      context 'when user paginator exists' do
        let!(:user_paginator) { stub_const('UserPaginator', base_class_from(admin_application_paginator)) }
        let!(:admin_user_paginator) { stub_const('Admin::UserPaginator', base_class_from(admin_application_paginator)) }

        it { is_expected.to eq UserPaginator }
      end
    end
  end
end
