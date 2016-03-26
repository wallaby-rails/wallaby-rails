require 'rails_helper'

describe 'partial' do
  let(:partial)     { "wallaby/resources/form/#{ field_name }.html.erb" }
  let(:form)        { Wallaby::FormBuilder.new object.model_name.param_key, object, view, { } }
  let(:object)      { AllPostgresType.new field_name => value }
  let(:field_name)  { :point }
  let(:value)       { [ 3, 4 ] }
  let(:metadata)    { Hash.new }

  before { render partial, form: form, object: object, field_name: field_name, value: value, metadata: metadata }

  it 'renders the point form' do
    expect(rendered).to eq "<div class=\"form-group \">\n  <label for=\"all_postgres_type_point\">Point</label>\n  <div class=\"row\">\n    <div class=\"col-xs-6 col-sm-3\">\n      <div class=\"input-group\">\n        <span class=\"input-group-addon\">X</span>\n        <input value=\"3\" multiple=\"multiple\" class=\"form-control\" type=\"number\" name=\"all_postgres_type[point][]\" id=\"all_postgres_type_point\" />\n      </div>\n    </div>\n    <div class=\"col-xs-6 col-sm-3\">\n      <div class=\"input-group\">\n        <span class=\"input-group-addon\">Y</span>\n        <input value=\"4\" multiple=\"multiple\" class=\"form-control\" type=\"number\" name=\"all_postgres_type[point][]\" id=\"all_postgres_type_point\" />\n      </div>\n    </div>\n  </div>\n  \n</div>\n"
  end

  context 'when value is nil' do
    let(:value) { nil }
    it 'renders empty input' do
      expect(rendered).to eq "<div class=\"form-group \">\n  <label for=\"all_postgres_type_point\">Point</label>\n  <div class=\"row\">\n    <div class=\"col-xs-6 col-sm-3\">\n      <div class=\"input-group\">\n        <span class=\"input-group-addon\">X</span>\n        <input multiple=\"multiple\" class=\"form-control\" type=\"number\" name=\"all_postgres_type[point][]\" id=\"all_postgres_type_point\" />\n      </div>\n    </div>\n    <div class=\"col-xs-6 col-sm-3\">\n      <div class=\"input-group\">\n        <span class=\"input-group-addon\">Y</span>\n        <input multiple=\"multiple\" class=\"form-control\" type=\"number\" name=\"all_postgres_type[point][]\" id=\"all_postgres_type_point\" />\n      </div>\n    </div>\n  </div>\n  \n</div>\n"
    end
  end
end
