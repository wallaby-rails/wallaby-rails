require 'rails_helper'

partial_name = 'form/email'
describe partial_name do
  let(:partial)     { "wallaby/resources/#{ partial_name }.html.erb" }
  let(:form)        { Wallaby::FormBuilder.new object.model_name.param_key, object, view, { } }
  let(:object)      { AllPostgresType.new field_name => value }
  let(:field_name)  { :string }
  let(:value)       { 'tian@reinteractive.com' }
  let(:metadata)    { {} }

  before { render partial, form: form, object: object, field_name: field_name, value: value, metadata: metadata }

  it 'renders the email form' do
    expect(rendered).to eq "<div class=\"form-group \">\n  <label for=\"all_postgres_type_string\">String</label>\n  <input class=\"form-control\" type=\"email\" value=\"tian@reinteractive.com\" name=\"all_postgres_type[string]\" id=\"all_postgres_type_string\" />\n  \n</div>\n"
  end

  context 'when value is nil' do
    let(:value) { nil }
    it 'renders empty input' do
      expect(rendered).to eq "<div class=\"form-group \">\n  <label for=\"all_postgres_type_string\">String</label>\n  <input class=\"form-control\" type=\"email\" name=\"all_postgres_type[string]\" id=\"all_postgres_type_string\" />\n  \n</div>\n"
    end
  end
end
