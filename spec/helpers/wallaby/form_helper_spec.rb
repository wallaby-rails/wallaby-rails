require 'rails_helper'

describe Wallaby::FormHelper do
  include Wallaby::LinksHelper
  include Wallaby::BaseHelper

  describe '#form_type_partial_render' do
    let(:form) { Wallaby::FormBuilder.new object_name, object, helper, {} }
    let(:object_name) { object.model_name.param_key }
    let(:object) { Wallaby::ResourceDecorator.new Product.new(name: 'product_name') }

    describe 'partials', prefixes: ['wallaby/resources/form'] do
      it 'renders a type partial' do
        helper.params[:action] = 'edit'
        expect(helper.type_render('integer', field_name: 'name', form: form)).to match 'type="number"'
      end
    end
  end

  describe '#remote_url' do
    it 'returns remote url' do
      expect(helper.remote_url('/path_to_api', Product)).to eq '/path_to_api'
      expect(helper.remote_url(nil, Product)).to eq '/admin/products?per=20&q=QUERY'
    end
  end

  describe '#polymorphic_options' do
    it 'returns dropdown options (klass => url) for polymorphic class' do
      metadata = {}
      expect(helper.polymorphic_options(metadata)).to eq ''

      metadata = { polymorphic_list: [Product, Category] }
      expect(helper.polymorphic_options(metadata)).to eq "<option data-url=\"/admin/products?per=20&amp;q=QUERY\" value=\"Product\">Product</option>\n<option data-url=\"/admin/categories?per=20&amp;q=QUERY\" value=\"Category\">Category</option>"

      metadata = { remote_urls: { Product => 'product_url', Category => 'category_url' }, polymorphic_list: [Product, Category] }
      expect(helper.polymorphic_options(metadata)).to eq "<option data-url=\"product_url\" value=\"Product\">Product</option>\n<option data-url=\"category_url\" value=\"Category\">Category</option>"
    end
  end

  describe '#hint_of' do
    it 'returns dropdown options (klass => url) for polymorphic class' do
      metadata = { type: 'unkown' }
      expect(helper.hint_of(metadata)).to be_nil

      metadata = { hint: 'this is a hint', type: 'unkown' }
      expect(helper.hint_of(metadata)).to include 'this is a hint'

      metadata = { type: 'box' }
      expect(helper.hint_of(metadata)).to include I18n.t('wallaby.hints.box_html')
    end
  end
end
