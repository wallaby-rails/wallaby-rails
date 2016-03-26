require 'rails_helper'

describe 'partial' do
  let(:partial)     { 'wallaby/resources/form/has_one.html.erb' }
  let(:form)        { Wallaby::FormBuilder.new object.model_name.param_key, object, view, { } }
  let(:object)      { Product.new field_name => value }
  let(:field_name)  { :product_detail }
  let(:value)       { ProductDetail.new id: 1 }
  let(:metadata)    { Hash name: "product_detail", type: "has_one", label: "Product Detail", is_association: true, is_polymorphic: false, is_through: false, has_scope: false, foreign_key: "product_detail_id", polymorphic_type: nil, polymorphic_list: [], class: ProductDetail }

  before do
    render partial, form: form, object: object, field_name: field_name, value: value, metadata: metadata
  end

  it 'renders edit link' do
    expect(rendered).to eq "<div class=\"form-group \">\n  <label for=\"product_product_detail\">Product Detail</label>\n  <div>\n    <a class=\"text-warning\" href=\"/admin/product_details/1/edit\">Edit 1</a>\n  </div>\n</div>\n"
  end

  context 'when value is nil' do
    let(:value)   { nil }

    it 'renders create link' do
      expect(rendered).to eq "<div class=\"form-group \">\n  <label for=\"product_product_detail\">Product Detail</label>\n  <div>\n    <a class=\"text-success\" href=\"/admin/product_details/new\">Create Product Detail</a>\n  </div>\n</div>\n"
    end
  end
end
