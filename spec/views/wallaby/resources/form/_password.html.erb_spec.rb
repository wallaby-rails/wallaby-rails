require 'rails_helper'

partial_name = 'form/password'
describe partial_name do
  let(:partial)     { "wallaby/resources/#{ partial_name }.html.erb" }
  let(:form)        { Wallaby::FormBuilder.new object.model_name.param_key, object, view, { } }
  let(:object)      { AllPostgresType.new field_name => value }
  let(:field_name)  { :string }
  let(:value)       { 'this is a text for more than 20 characters' }
  let(:metadata)    { Hash.new }

  before { render partial, form: form, object: object, field_name: field_name, value: value, metadata: metadata }

  it 'renders the password form with empty value' do
    expect(rendered).to eq "<div class=\"form-group \">\n  <label for=\"all_postgres_type_string\">String</label>\n  <input value=\"\" class=\"form-control\" type=\"password\" name=\"all_postgres_type[string]\" id=\"all_postgres_type_string\" />\n  \n</div>\n"
  end

  context 'when value is nil' do
    let(:value) { nil }
    it 'renders empty value' do
      expect(rendered).to eq "<div class=\"form-group \">\n  <label for=\"all_postgres_type_string\">String</label>\n  <input value=\"\" class=\"form-control\" type=\"password\" name=\"all_postgres_type[string]\" id=\"all_postgres_type_string\" />\n  \n</div>\n"
    end
  end
end
