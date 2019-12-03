require 'rails_helper'

describe Wallaby::ResourcesController, type: :controller do
  describe '#authorizer' do
    it 'shows deprecation message' do
      controller.params[:resources] = 'products'
      expect do
        controller.authorizer
      end.to output(a_string_starting_with("[DEPRECATION] `authorizer` will be removed from 5.3.*. Please use `current_authorizer` instead.\n")).to_stderr
      expect(controller.authorizer).to be_a Wallaby::ModelAuthorizer
    end
  end

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

describe Wallaby::FormHelper, type: :helper do
  include Wallaby::LinksHelper
  include Wallaby::BaseHelper

  describe '#form_type_partial_render' do
    let(:form) { Wallaby::FormBuilder.new object_name, object, helper, {} }
    let(:object_name) { object.model_name.param_key }
    let(:object) { Wallaby::ResourceDecorator.new Product.new(name: 'product_name') }

    describe 'partials', prefixes: ['wallaby/resources/form'] do
      it 'shows deprecation message' do
        helper.params[:action] = 'edit'
        expect do
          helper.form_type_partial_render('integer', field_name: 'name', form: form)
        end.to output(a_string_starting_with("[DEPRECATION] `form_type_partial_render` will be removed from 5.3.*. Please use `type_render` instead.\n")).to_stderr
      end
    end

    describe 'index_params' do
      it 'shows deprecation message' do
        expect do
          helper.index_params
        end.to output(a_string_starting_with("[DEPRECATION] `index_params` will be removed from 5.3.*.\n")).to_stderr
      end
    end

    describe 'paginator_of' do
      it 'shows deprecation message' do
        expect do
          helper.paginator_of Product, Product.all, {}
        end.to output(a_string_starting_with("[DEPRECATION] `paginator_of` will be removed from 5.3.*. Please use `current_paginator` instead.\n")).to_stderr
      end
    end
  end
end

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

describe Wallaby::ResourcesHelper, type: :helper do
  describe '#type_partial_render', prefixes: ['wallaby/resources/index'] do
    let(:object) { Wallaby::ResourceDecorator.new Product.new(name: 'product_name') }

    before { helper.params[:action] = 'show' }

    it 'shows deprecation message' do
      expect do
        helper.type_partial_render('integer', field_name: 'name', object: object)
      end.to output(a_string_starting_with("[DEPRECATION] `type_partial_render` will be removed from 5.3.*. Please use `type_render` instead.\n")).to_stderr
    end
  end
end
