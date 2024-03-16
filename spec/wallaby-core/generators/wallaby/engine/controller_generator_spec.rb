# frozen_string_literal: true

require 'rails_helper'
require 'generator_spec'
require 'generators/wallaby/engine/controller/controller_generator'

describe Wallaby::Engine::ControllerGenerator, 'with a name', type: :generator do
  let!(:admin_application_controller) { stub_const('Admin::ApplicationController', base_class_from(Wallaby::ResourcesController)) }

  destination File.expand_path('../../../../tmp', __dir__)
  arguments %w[admin/users]

  before do
    prepare_destination
    run_generator
  end

  specify do
    expect(destination_root).to(have_structure do
      directory 'app' do
        directory 'controllers' do
          directory 'admin' do
            file 'users_controller.rb' do
              contains 'class Admin::UsersController < Admin::ApplicationController'
              contains '# self.model_class = Admin::User'
            end
          end
        end
      end
    end)
  end
end

describe Wallaby::Engine::ControllerGenerator, 'with name and parent', type: :generator do
  destination File.expand_path('../../../../tmp', __dir__)
  arguments %w[admin/users backend/application]

  before do
    prepare_destination
    run_generator
  end

  specify do
    expect(destination_root).to(have_structure do
      directory 'app' do
        directory 'controllers' do
          directory 'admin' do
            file 'users_controller.rb' do
              contains 'class Admin::UsersController < Backend::ApplicationController'
            end
          end
        end
      end
    end)
  end
end
