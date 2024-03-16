# frozen_string_literal: true

require 'rails_helper'
require 'generator_spec'
require 'generators/wallaby/engine/install/install_generator'

describe Wallaby::Engine::InstallGenerator, 'with default', type: :generator do
  destination File.expand_path('../../../../tmp', __dir__)

  before do
    prepare_destination
    run_generator
  end

  specify do
    expect(destination_root).to(have_structure do
      directory 'config' do
        directory 'initializers' do
          file 'wallaby.rb' do
            contains 'Wallaby.config do |config|'
          end
        end
      end
      directory 'app' do
        directory 'controllers' do
          directory 'admin' do
            file 'application_controller.rb' do
              contains 'module Admin'
              contains 'class ApplicationController < Wallaby::ResourcesController'
            end
          end
        end
        directory 'decorators' do
          directory 'admin' do
            file 'application_decorator.rb' do
              contains 'module Admin'
              contains 'class ApplicationDecorator < Wallaby::ResourceDecorator'
            end
          end
        end
        directory 'servicers' do
          directory 'admin' do
            file 'application_servicer.rb' do
              contains 'module Admin'
              contains 'class ApplicationServicer < Wallaby::ModelServicer'
            end
          end
        end
      end
    end)
  end
end

describe Wallaby::Engine::InstallGenerator, 'with argument backend', type: :generator do
  destination File.expand_path('../../../../tmp', __dir__)
  arguments %w[backend]

  before do
    prepare_destination
    run_generator
  end

  specify do
    expect(destination_root).to(have_structure do
      directory 'config' do
        directory 'initializers' do
          file 'wallaby.rb' do
            contains 'Wallaby.config do |config|'
          end
        end
      end
      directory 'app' do
        directory 'controllers' do
          directory 'backend' do
            file 'application_controller.rb' do
              contains 'module Backend'
              contains 'class ApplicationController < Wallaby::ResourcesController'
            end
          end
        end
        directory 'decorators' do
          directory 'backend' do
            file 'application_decorator.rb' do
              contains 'module Backend'
              contains 'class ApplicationDecorator < Wallaby::ResourceDecorator'
            end
          end
        end
        directory 'servicers' do
          directory 'backend' do
            file 'application_servicer.rb' do
              contains 'module Backend'
              contains 'class ApplicationServicer < Wallaby::ModelServicer'
            end
          end
        end
      end
    end)
  end
end
