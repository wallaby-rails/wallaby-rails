require 'rails_helper'

partial_name = 'form/belongs_to'
describe partial_name, :current_user do
  let(:partial) { "wallaby/resources/#{partial_name}.html.erb" }
  let(:form) { Wallaby::FormBuilder.new object.model_name.param_key, object, view, {} }
  let!(:object) { Product.create! field_name => value }
  let(:field_name) { metadata[:name] }
  let!(:value) { Category.create! id: 1, name: 'Mens' }
  let(:metadata) do
    {
      name: 'category', type: 'belongs_to', label: 'Category',
      is_association: true, is_polymorphic: false, is_through: false, has_scope: false, foreign_key: 'category_id', polymorphic_type: nil, polymorphic_list: [], class: Category
    }
  end

  before { render partial, form: form, object: object, field_name: field_name, value: value, metadata: metadata }

  it 'renders the belongs_to form' do
    expect(rendered).to eq "<div class=\"form-group \">\n  <label for=\"product_category_id\">Category</label>\n  <div class=\"row\">\n      <div class=\"col-xs-6 col-sm-4\">\n        <select class=\"form-control\" name=\"product[category_id]\" id=\"product_category_id\"><option value=\"\"></option>\n<option selected=\"selected\" value=\"1\">Mens</option></select>\n      </div>\n      <p class=\"help-block\">\n        Or <a class=\"resource__create\" href=\"/admin/categories/new\">Create Category</a>\n      </p>\n  </div>\n  \n</div>\n"
    expect(rendered).to match 'selected="selected"'
  end

  context 'when value is nil' do
    let(:object) { Product.new }

    it 'renders the belongs_to form' do
      expect(rendered).to eq "<div class=\"form-group \">\n  <label for=\"product_category_id\">Category</label>\n  <div class=\"row\">\n      <div class=\"col-xs-6 col-sm-4\">\n        <select class=\"form-control\" name=\"product[category_id]\" id=\"product_category_id\"><option value=\"\"></option>\n<option value=\"1\">Mens</option></select>\n      </div>\n      <p class=\"help-block\">\n        Or <a class=\"resource__create\" href=\"/admin/categories/new\">Create Category</a>\n      </p>\n  </div>\n  \n</div>\n"
      expect(rendered).not_to match 'selected="selected"'
    end
  end

  context 'when it is polymorphic' do
    let(:object) { Picture.new imageable: value }
    let(:field_name) { :imageable_id }
    let(:value) { Product.new id: 1, name: 'Snowboard' }
    let(:metadata) do
      {
        name: 'imageable', type: 'belongs_to', label: 'Imageable', is_association: true,
        is_polymorphic: true, is_through: false, has_scope: false, foreign_key: 'imageable_id', polymorphic_type: 'imageable_type', polymorphic_list: [Product], class: nil
      }
    end

    it 'renders the polymorphic form' do
      expect(rendered).to eq "<div class=\"form-group \">\n  <label for=\"picture_imageable_id\">Imageable</label>\n  <div class=\"row\">\n      <div class=\"col-xs-6 col-sm-4\">\n        <select class=\"form-control\" name=\"picture[imageable_type]\" id=\"picture_imageable_type\"><option value=\"\"></option>\n<option selected=\"selected\" value=\"Product\">Product</option></select>\n      </div>\n      <div class=\"col-xs-3\">\n        <input class=\"form-control\" type=\"text\" value=\"1\" name=\"picture[imageable_id]\" id=\"picture_imageable_id\" />\n      </div>\n  </div>\n  \n</div>\n"
      expect(rendered).to match 'selected="selected"'
    end

    context 'when value is nil' do
      let(:object) { Picture.new }
      let(:value) { nil }

      it 'renders the polymorphic form' do
        expect(rendered).to eq "<div class=\"form-group \">\n  <label for=\"picture_imageable_id\">Imageable</label>\n  <div class=\"row\">\n      <div class=\"col-xs-6 col-sm-4\">\n        <select class=\"form-control\" name=\"picture[imageable_type]\" id=\"picture_imageable_type\"><option value=\"\"></option>\n<option value=\"Product\">Product</option></select>\n      </div>\n      <div class=\"col-xs-3\">\n        <input class=\"form-control\" type=\"text\" name=\"picture[imageable_id]\" id=\"picture_imageable_id\" />\n      </div>\n  </div>\n  \n</div>\n"
        expect(rendered).not_to match 'selected="selected"'
      end
    end
  end
end
