require 'rails_helper'

partial_name = 'form/color'
describe partial_name do
  let(:partial)     { "wallaby/resources/#{partial_name}.html.erb" }
  let(:form)        { Wallaby::FormBuilder.new object.model_name.param_key, object, view, {} }
  let(:object)      { AllPostgresType.new field_name => value }
  let(:field_name)  { :string }
  let(:value)       { '#000000' }
  let(:metadata)    { {} }

  before { render partial, form: form, object: object, field_name: field_name, value: value, metadata: metadata }

  it 'renders the string form' do
    expect(rendered).to eq "<div class=\"form-group \">\n  <label for=\"all_postgres_type_string\">String</label>\n  <div class=\"row\">\n    <div class=\"col-xs-6 col-sm-3\">\n      <input class=\"form-control\" data-init=\"colorpicker\" type=\"text\" value=\"#000000\" name=\"all_postgres_type[string]\" id=\"all_postgres_type_string\" />\n    </div>\n  </div>\n  \n</div>\n\n"
  end

  context 'when value is nil' do
    let(:value) { nil }
    it 'renders empty input' do
      expect(rendered).to eq "<div class=\"form-group \">\n  <label for=\"all_postgres_type_string\">String</label>\n  <div class=\"row\">\n    <div class=\"col-xs-6 col-sm-3\">\n      <input class=\"form-control\" data-init=\"colorpicker\" type=\"text\" name=\"all_postgres_type[string]\" id=\"all_postgres_type_string\" />\n    </div>\n  </div>\n  \n</div>\n\n"
    end
  end
end
