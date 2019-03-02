require 'rails_helper'

describe 'ResourcePaginator' do
  it 'shows deprecation message' do
    expect do
      class ProductPaingator < Wallaby::ResourcePaginator
      end
    end.to output(a_string_starting_with("[DEPRECATION] `Wallaby::ResourcePaginator` will be removed from 5.3.*. Please inherit from `Wallaby::ModelPaginator` instead.\n")).to_stderr
  end
end

describe 'Map.resource_paginator' do
  it 'shows deprecation message' do
    mapping = Wallaby::Configuration::Mapping.new
    expect do
      mapping.resource_paginator = String
    end.to output(a_string_starting_with("[DEPRECATION] `resource_paginator=` will be removed from 5.3.*. Please use `model_paginator=` instead.\n")).to_stderr
    expect(mapping.model_paginator).to eq String
  end
end

describe Wallaby::ResourcesController, type: :controller do
  describe '#current_model_service' do
    it 'shows deprecation message' do
      controller.params[:resources] = 'products'
      expect do
        controller.current_model_service
      end.to output(a_string_starting_with("[DEPRECATION] `current_model_service` will be removed from 5.3.*. Please use `current_servicer` instead.\n")).to_stderr
      expect(controller.current_model_service).to be_a Wallaby::ModelServicer
      expect(controller.current_model_service).to eq controller.current_servicer
    end
  end

  describe '#authorizer' do
    it 'shows deprecation message' do
      controller.params[:resources] = 'products'
      expect do
        controller.authorizer
      end.to output(a_string_starting_with("[DEPRECATION] `authorizer` will be removed from 5.3.*. Please use `current_authorizer` instead.\n")).to_stderr
      expect(controller.authorizer).to be_a Wallaby::ModelAuthorizer
    end
  end
end

describe Wallaby::Utils do
  describe '.find_filter_name' do
    it 'shows deprecation message' do
      expect do
        described_class.find_filter_name nil, {}
      end.to output(a_string_starting_with("[DEPRECATION] `Wallaby::Utils.find_filter_name` will be removed from 5.3.*. Please use `Wallaby::FilterUtils.filter_name_by` instead.\n")).to_stderr
    end
  end
end
