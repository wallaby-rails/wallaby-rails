require 'rails_helper'

partial_name = 'form/macaddr'
describe partial_name do
  let(:partial)   { "wallaby/resources/#{ partial_name }.html.erb" }
  let(:form)        { Wallaby::FormBuilder.new object.model_name.param_key, object, view, { } }
  let(:object)      { AllPostgresType.new field_name => value }
  let(:field_name)  { :macaddr }
  let(:value)       { '32:01:16:6d:05:ef' }
  let(:metadata)    { Hash.new }

  before { render partial, form: form, object: object, field_name: field_name, value: value, metadata: metadata }

  it 'renders the macaddr form' do
    expect(rendered).to eq "<div class=\"form-group \">\n  <label for=\"all_postgres_type_macaddr\">Macaddr</label>\n  <div class=\"row\">\n    <div class=\"col-xs-6 col-sm-3\">\n      <input class=\"form-control\" type=\"text\" value=\"32:01:16:6d:05:ef\" name=\"all_postgres_type[macaddr]\" id=\"all_postgres_type_macaddr\" />\n    </div>\n  </div>\n  \n</div>\n"
  end

  context 'when value is nil' do
    let(:value) { nil }
    it 'renders empty input' do
      expect(rendered).to eq "<div class=\"form-group \">\n  <label for=\"all_postgres_type_macaddr\">Macaddr</label>\n  <div class=\"row\">\n    <div class=\"col-xs-6 col-sm-3\">\n      <input class=\"form-control\" type=\"text\" name=\"all_postgres_type[macaddr]\" id=\"all_postgres_type_macaddr\" />\n    </div>\n  </div>\n  \n</div>\n"
    end
  end
end
