require 'rails_helper'

describe 'partial', :current_user do
  let(:partial)     { 'wallaby/resources/form/has_many.html.erb' }
  let(:form)        { Wallaby::FormBuilder.new object.model_name.param_key, object, view, { } }
  let(:object)      { Product.new field_name => value }
  let(:field_name)  { metadata[:name] }
  let(:value)       { [ Tag.new(id: 1, name: 'Toy') ] }
  let(:metadata)    do
    Hash name: "tags", type: "has_and_belongs_to_many", label: "Tags",
      is_association: true, is_polymorphic: false, is_through: false, has_scope: false, foreign_key: "tag_ids", polymorphic_type: nil, polymorphic_list: [], class: Tag
  end

  before do
    allow(view).to receive(:model_choices) { [ [ value.first.id, value.first.id ] ] }
    render partial, form: form, object: object, field_name: field_name, value: value, metadata: metadata
  end

  it 'renders the has_many form' do
    expect(rendered).to eq "<div class=\"form-group \">\n  <label for=\"product_tag_ids\">Tags</label>\n  <div class=\"row\">\n    <div class=\"col-xs-6 col-sm-3\">\n      <input name=\"product[tag_ids][]\" type=\"hidden\" value=\"\" /><select class=\"form-control\" multiple=\"multiple\" name=\"product[tag_ids][]\" id=\"product_tag_ids\"><option selected=\"selected\" value=\"1\">1</option></select>\n      <p class=\"help-block\">\n        Press CTRL to select/deselect multiple items.\n        Or <a class=\"text-success\" href=\"/admin/tags/new\">Create Tag</a>\n      </p>\n    </div>\n  </div>\n  \n</div>\n"
    expect(rendered).to match "selected=\"selected\""
  end

  context 'when value is nil' do
    let(:object)  { Product.new }

    it 'renders the has_many form' do
      expect(rendered).to eq "<div class=\"form-group \">\n  <label for=\"product_tag_ids\">Tags</label>\n  <div class=\"row\">\n    <div class=\"col-xs-6 col-sm-3\">\n      <input name=\"product[tag_ids][]\" type=\"hidden\" value=\"\" /><select class=\"form-control\" multiple=\"multiple\" name=\"product[tag_ids][]\" id=\"product_tag_ids\"><option value=\"1\">1</option></select>\n      <p class=\"help-block\">\n        Press CTRL to select/deselect multiple items.\n        Or <a class=\"text-success\" href=\"/admin/tags/new\">Create Tag</a>\n      </p>\n    </div>\n  </div>\n  \n</div>\n"
      expect(rendered).not_to match "selected=\"selected\""
    end
  end
end