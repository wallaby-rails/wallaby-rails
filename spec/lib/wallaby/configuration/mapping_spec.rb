require 'rails_helper'

describe Wallaby::Configuration::Mapping do
  it_behaves_like \
    'has attribute with default value',
    :resources_controller, Wallaby::ResourcesController

  context 'when admin application controller exists' do
    context 'it doesnt inherit form resources controller' do
      before { stub_const('Admin::ApplicationController', Class.new) }
      it_behaves_like \
        'has attribute with default value',
        :resources_controller, Wallaby::ResourcesController
    end

    context 'it inherits form resources controller' do
      before { stub_const('Admin::ApplicationController', Class.new(Wallaby::ResourcesController)) }
      it_behaves_like \
        'has attribute with default value',
        :resources_controller, -> { Admin::ApplicationController }
    end
  end

  it_behaves_like \
    'has attribute with default value',
    :resource_decorator, Wallaby::ResourceDecorator

  it_behaves_like \
    'has attribute with default value',
    :resource_paginator, Wallaby::ResourcePaginator

  it_behaves_like \
    'has attribute with default value',
    :model_servicer, Wallaby::ModelServicer
end
