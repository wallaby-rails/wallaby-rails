# frozen_string_literal: true

require 'rails_helper'

describe 'Wallaby::FormBuilder', type: :helper do
  subject { Wallaby::FormBuilder.new object_name, object, helper, {} }

  let(:object_name) { object.model_name.param_key }
  let(:object) { Product.new }

  describe '#error_class' do
    it 'returns error class if error' do
      expect(subject.error_class(:name)).to be_nil
      object.errors.add :name, 'not valid'
      expect(subject.error_class(:name)).to eq 'has-error'
    end
  end

  describe '#error_messages' do
    it 'returns error messages if any' do
      expect(subject.error_messages(:name)).to be_nil
      object.errors.add :name, 'not valid'
      object.errors.add :name, 'not unique'
      expect(subject.error_messages(:name)).to eq '<ul class="errors"><li><small>not valid</small></li><li><small>not unique</small></li></ul>'
    end
  end

  describe '#label' do
    it 'returns the label' do
      expect(subject.label(:name, 'some text')).to eq '<label for="product_name">some text</label>'
      expect(subject.label(:name, -> { 'some text' })).to eq '<label for="product_name">some text</label>'
    end
  end

  describe '#select' do
    it 'returns the select' do
      expect(subject.select(:name, [1, 2])).to eq "<select name=\"product[name]\" id=\"product_name\"><option value=\"1\">1</option>\n<option value=\"2\">2</option></select>"
      expect(subject.select(:name, -> { [1, 2] })).to eq "<select name=\"product[name]\" id=\"product_name\"><option value=\"1\">1</option>\n<option value=\"2\">2</option></select>"
    end
  end

  describe 'missing methods' do
    it 'delegates to helper' do
      expect(Wallaby::FormBuilder).not_to respond_to :index_path
      expect(subject).to respond_to(:index_path)
      expect(subject.index_path(Product)).to eq '/admin/products'
    end
  end
end
