require 'rails_helper'

describe Wallaby::Configuration::Mapping do
  it_behaves_like \
    'has attribute with default value',
    :resources_controller, Wallaby::ResourcesController

  it_behaves_like \
    'has attribute with default value',
    :resource_decorator, Wallaby::ResourceDecorator

  it_behaves_like \
    'has attribute with default value',
    :model_servicer, Wallaby::ModelServicer
end
