require 'rails_helper'

partial_name = 'form/int8range'
describe partial_name do
  let(:partial)   { "wallaby/resources/#{ partial_name }.html.erb" }
  let(:form)        { Wallaby::FormBuilder.new object.model_name.param_key, object, view, { } }
  let(:object)      { AllPostgresType.new field_name => value }
  let(:field_name)  { :int8range }
  let(:value)       { 0..100 }
  let(:metadata)    { Hash.new }

  before { render partial, form: form, object: object, field_name: field_name, value: value, metadata: metadata }

  it 'renders the int8range form' do
    expect(rendered).to eq "<div class=\"form-group \">\n  <label for=\"all_postgres_type_int8range\">Int8range</label>\n  <div class=\"row\">\n    <div class=\"col-xs-6 col-sm-3\">\n      <div class=\"input-group\">\n        <span class=\"input-group-addon\">F</span>\n        <input value=\"0\" multiple=\"multiple\" class=\"form-control\" type=\"number\" name=\"all_postgres_type[int8range][]\" id=\"all_postgres_type_int8range\" />\n      </div>\n    </div>\n    <div class=\"col-xs-6 col-sm-3\">\n      <div class=\"input-group\">\n        <span class=\"input-group-addon\">T</span>\n        <input value=\"100\" multiple=\"multiple\" class=\"form-control\" type=\"number\" name=\"all_postgres_type[int8range][]\" id=\"all_postgres_type_int8range\" />\n      </div>\n    </div>\n  </div>\n  \n</div>\n"
  end

  context 'when value is nil' do
    let(:value) { nil }
    it 'renders empty input' do
      expect(rendered).to eq "<div class=\"form-group \">\n  <label for=\"all_postgres_type_int8range\">Int8range</label>\n  <div class=\"row\">\n    <div class=\"col-xs-6 col-sm-3\">\n      <div class=\"input-group\">\n        <span class=\"input-group-addon\">F</span>\n        <input multiple=\"multiple\" class=\"form-control\" type=\"number\" name=\"all_postgres_type[int8range][]\" id=\"all_postgres_type_int8range\" />\n      </div>\n    </div>\n    <div class=\"col-xs-6 col-sm-3\">\n      <div class=\"input-group\">\n        <span class=\"input-group-addon\">T</span>\n        <input multiple=\"multiple\" class=\"form-control\" type=\"number\" name=\"all_postgres_type[int8range][]\" id=\"all_postgres_type_int8range\" />\n      </div>\n    </div>\n  </div>\n  \n</div>\n"
    end
  end
end
