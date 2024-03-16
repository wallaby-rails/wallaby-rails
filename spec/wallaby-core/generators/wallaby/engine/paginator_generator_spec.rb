# frozen_string_literal: true

require 'rails_helper'
require 'generator_spec'
require 'generators/wallaby/engine/paginator/paginator_generator'

describe Wallaby::Engine::PaginatorGenerator, 'with a name', type: :generator do
  destination File.expand_path('../../../../tmp', __dir__)
  arguments %w[admin/user]

  before do
    prepare_destination
    run_generator
  end

  specify do
    expect(destination_root).to(have_structure do
      directory 'app' do
        directory 'paginators' do
          directory 'admin' do
            file 'user_paginator.rb' do
              contains 'class Admin::UserPaginator < Wallaby::ModelPaginator'
              contains '# self.model_class = Admin::User'
            end
          end
        end
      end
    end)
  end
end

describe Wallaby::Engine::PaginatorGenerator, 'with name and parent', type: :generator do
  destination File.expand_path('../../../../tmp', __dir__)
  arguments %w[admin/user backend/application]

  before do
    prepare_destination
    run_generator
  end

  specify do
    expect(destination_root).to(have_structure do
      directory 'app' do
        directory 'paginators' do
          directory 'admin' do
            file 'user_paginator.rb' do
              contains 'class Admin::UserPaginator < Backend::ApplicationPaginator'
            end
          end
        end
      end
    end)
  end
end
