# frozen_string_literal: true

require 'rails_helper'
require 'generator_spec'
require 'generators/wallaby/engine/servicer/servicer_generator'

describe Wallaby::Engine::ServicerGenerator, 'with a name', type: :generator do
  destination File.expand_path('../../../../tmp', __dir__)
  arguments %w[admin/user]

  before do
    prepare_destination
    run_generator
  end

  specify do
    expect(destination_root).to(have_structure do
      directory 'app' do
        directory 'servicers' do
          directory 'admin' do
            file 'user_servicer.rb' do
              contains 'class Admin::UserServicer < Wallaby::ModelServicer'
              contains '# self.model_class = Admin::User'
            end
          end
        end
      end
    end)
  end
end

describe Wallaby::Engine::ServicerGenerator, 'with name and parent', type: :generator do
  destination File.expand_path('../../../../tmp', __dir__)
  arguments %w[admin/user backend/application]

  before do
    prepare_destination
    run_generator
  end

  specify do
    expect(destination_root).to(have_structure do
      directory 'app' do
        directory 'servicers' do
          directory 'admin' do
            file 'user_servicer.rb' do
              contains 'class Admin::UserServicer < Backend::ApplicationServicer'
            end
          end
        end
      end
    end)
  end
end
