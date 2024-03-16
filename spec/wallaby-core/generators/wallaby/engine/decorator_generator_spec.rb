# frozen_string_literal: true

require 'rails_helper'
require 'generator_spec'
require 'generators/wallaby/engine/decorator/decorator_generator'

describe Wallaby::Engine::DecoratorGenerator, 'with a name', type: :generator do
  destination File.expand_path('../../../../tmp', __dir__)
  arguments %w[admin/user]

  before do
    prepare_destination
    run_generator
  end

  specify do
    expect(destination_root).to(have_structure do
      directory 'app' do
        directory 'decorators' do
          directory 'admin' do
            file 'user_decorator.rb' do
              contains 'class Admin::UserDecorator < Wallaby::ResourceDecorator'
              contains '# self.model_class = Admin::User'
            end
          end
        end
      end
    end)
  end
end

describe Wallaby::Engine::DecoratorGenerator, 'with name and parent', type: :generator do
  destination File.expand_path('../../../../tmp', __dir__)
  arguments %w[admin/user backend/application]

  before do
    prepare_destination
    run_generator
  end

  specify do
    expect(destination_root).to(have_structure do
      directory 'app' do
        directory 'decorators' do
          directory 'admin' do
            file 'user_decorator.rb' do
              contains 'class Admin::UserDecorator < Backend::ApplicationDecorator'
            end
          end
        end
      end
    end)
  end
end
