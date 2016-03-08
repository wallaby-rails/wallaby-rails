require 'rails_helper'

describe Wallaby::FormHelper do
  describe '#form_type_partial_render' do
    it 'checks the arguments' do
      expect{ helper.form_type_partial_render }.to raise_error ArgumentError
      expect{ helper.form_type_partial_render 'integer', field_name: 'name' }.to raise_error ArgumentError
      expect{ helper.form_type_partial_render 'integer', field_name: 'name', form: double(object: Product.new) }.to raise_error ArgumentError

      expect{ helper.form_type_partial_render 'integer', field_name: 'name', form: double(object: Wallaby::ResourceDecorator.new(Product.new)) }.not_to raise_error ArgumentError
    end

    it 'renders a type partial' do
      object = Wallaby::ResourceDecorator.new Product.new(name: 'product_name')
      form = double object: object
      expect(helper).to receive(:render).with('form/integer', field_name: 'name', form: form, object: object, metadata: object.metadata_of('name'), value: 'product_name') { true }
      helper.form_type_partial_render 'integer', field_name: 'name', form: form
    end
  end

  describe '#form_group_classes' do
    it 'returns form group classes' do
      product = Product.new
      decorated = helper.decorate product
      expect(helper.form_group_classes decorated, 'name').to be_blank

      product.errors.add 'name', 'must have error'
      expect(helper.form_group_classes decorated, 'name').to eq "has-error"
    end
  end

  describe '#form_field_error_messages' do
    it 'returns error messages' do
      product = Product.new
      decorated = helper.decorate product
      expect(helper.form_field_error_messages decorated, 'name').to eq "<ul class=\"text-danger\"></ul>"

      product.errors.add 'name', 'must have error'
      expect(helper.form_field_error_messages decorated, 'name').to eq "<ul class=\"text-danger\"><li><small>must have error</small></li></ul>"
    end
  end

  describe '#model_choices' do
    it 'returns a list of choise for select' do
      collection = [
        Product.new(id: 1, name: 'Coconut'),
        Product.new(id: 2, name: 'Banana')
      ]
      model_decorator = double collection: collection
      expect(helper.model_choices model_decorator).to eq [["Coconut", 1], ["Banana", 2]]
    end
  end
end
