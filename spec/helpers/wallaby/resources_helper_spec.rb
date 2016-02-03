require 'rails_helper'

describe Wallaby::ResourcesHelper do
  describe '#type_partial_render' do
    it 'checks the arguments' do
      expect{ helper.type_partial_render }.to raise_error ArgumentError
      expect{ helper.type_partial_render 'integer', field_name: 'name' }.to raise_error ArgumentError
      expect{ helper.type_partial_render 'integer', field_name: 'name', object: Product.new }.to raise_error ArgumentError
      expect{ helper.type_partial_render 'integer', field_name: 'name', object: Wallaby::ResourceDecorator.new(Product.new) }.not_to raise_error ArgumentError
    end

    it 'renders a type partial' do
      object = Wallaby::ResourceDecorator.new Product.new(name: 'product_name')
      allow(helper).to receive(:action_name) { 'index' }
      expect(helper).to receive(:render).with('index/integer', object: object, field_name: 'name', metadata: object.metadata_of('name'), value: 'product_name')
      helper.type_partial_render 'integer', object: object, field_name: 'name'
    end
  end

  describe '#show_title' do
    it 'returns a title for decorated resources' do
      expect{ helper.show_title }.to raise_error ArgumentError
    end
  end
end
