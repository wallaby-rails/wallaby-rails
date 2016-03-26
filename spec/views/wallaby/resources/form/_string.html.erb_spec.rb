require 'rails_helper'

describe 'partial' do
  let(:partial)     { "wallaby/resources/form/#{ field_name }.html.erb" }
  let(:form)        { Wallaby::FormBuilder.new object.model_name.param_key, object, view, { } }
  let(:object)      { AllPostgresType.new field_name => value }
  let(:field_name)  { :string }
  let(:value)       { 'this is a text for more than 20 characters' }
  let(:metadata)    { Hash.new }

  before { render partial, form: form, object: object, field_name: field_name, value: value, metadata: metadata }

  it 'renders the string form' do
    expect(rendered).to eq "<div class=\"form-group \">\n  <label for=\"all_postgres_type_string\">String</label>\n  <input class=\"form-control\" type=\"text\" value=\"this is a text for more than 20 characters\" name=\"all_postgres_type[string]\" id=\"all_postgres_type_string\" />\n  \n</div>\n"
  end

  context 'when value is nil' do
    let(:value) { nil }
    it 'renders empty input' do
      expect(rendered).to eq "<div class=\"form-group \">\n  <label for=\"all_postgres_type_string\">String</label>\n  <input class=\"form-control\" type=\"text\" name=\"all_postgres_type[string]\" id=\"all_postgres_type_string\" />\n  \n</div>\n"
    end
  end
end
