require 'rails_helper'

partial_name = 'form/boolean'
describe partial_name do
  let(:partial)     { "wallaby/resources/#{partial_name}.html.erb" }
  let(:form)        { Wallaby::FormBuilder.new object.model_name.param_key, object, view, {} }
  let(:object)      { AllPostgresType.new field_name => value }
  let(:field_name)  { :boolean }
  let(:value)       { true }
  let(:metadata)    { {} }

  before { render partial, form: form, object: object, field_name: field_name, value: value, metadata: metadata }

  it 'renders the boolean form and ticks yes' do
    expect(rendered).to eq "<div class=\"form-group \">\n  <label for=\"all_postgres_type_boolean\">Boolean</label>\n  <div class=\"row\">\n    <div class=\"col-xs-12\">\n      <label class=\"radio-inline\">\n        <input type=\"radio\" value=\"true\" checked=\"checked\" name=\"all_postgres_type[boolean]\" id=\"all_postgres_type_boolean_true\" /> Yes\n      </label>\n      <label class=\"radio-inline\">\n        <input type=\"radio\" value=\"false\" name=\"all_postgres_type[boolean]\" id=\"all_postgres_type_boolean_false\" /> No\n      </label>\n    </div>\n  </div>\n  \n</div>\n"
    expect(rendered).to match "checked=\"checked\""
  end

  context 'when value is false' do
    let(:value) { false }
    it 'renders the boolean form and ticks no' do
      expect(rendered).to eq "<div class=\"form-group \">\n  <label for=\"all_postgres_type_boolean\">Boolean</label>\n  <div class=\"row\">\n    <div class=\"col-xs-12\">\n      <label class=\"radio-inline\">\n        <input type=\"radio\" value=\"true\" name=\"all_postgres_type[boolean]\" id=\"all_postgres_type_boolean_true\" /> Yes\n      </label>\n      <label class=\"radio-inline\">\n        <input type=\"radio\" value=\"false\" checked=\"checked\" name=\"all_postgres_type[boolean]\" id=\"all_postgres_type_boolean_false\" /> No\n      </label>\n    </div>\n  </div>\n  \n</div>\n"
      expect(rendered).to match "checked=\"checked\""
    end
  end

  context 'when value is nil' do
    let(:value) { nil }
    it 'renders the boolean form and ticks nothing' do
      expect(rendered).to eq "<div class=\"form-group \">\n  <label for=\"all_postgres_type_boolean\">Boolean</label>\n  <div class=\"row\">\n    <div class=\"col-xs-12\">\n      <label class=\"radio-inline\">\n        <input type=\"radio\" value=\"true\" name=\"all_postgres_type[boolean]\" id=\"all_postgres_type_boolean_true\" /> Yes\n      </label>\n      <label class=\"radio-inline\">\n        <input type=\"radio\" value=\"false\" name=\"all_postgres_type[boolean]\" id=\"all_postgres_type_boolean_false\" /> No\n      </label>\n    </div>\n  </div>\n  \n</div>\n"
      expect(rendered).not_to match "checked=\"checked\""
    end
  end
end
