require 'rails_helper'

partial_name = 'form/money'
describe partial_name do
  let(:partial)     { "wallaby/resources/#{partial_name}.html.erb" }
  let(:form)        { Wallaby::FormBuilder.new object.model_name.param_key, object, view, {} }
  let(:object)      { AllPostgresType.new field_name => value }
  let(:field_name)  { :money }
  let(:value)       { 100.88 }
  let(:metadata)    { {} }

  before { render partial, form: form, object: object, field_name: field_name, value: value, metadata: metadata }

  it 'renders the money form' do
    expect(rendered).to eq "<div class=\"form-group \">\n  <label for=\"all_postgres_type_money\">Money</label>\n  <div class=\"row\">\n    <div class=\"col-xs-6 col-sm-3\">\n      <div class=\"input-group\">\n        <span class=\"input-group-addon\">$</span>\n        <input class=\"form-control\" type=\"text\" value=\"100.88\" name=\"all_postgres_type[money]\" id=\"all_postgres_type_money\" />\n      </div>\n    </div>\n  </div>\n  \n</div>\n"
  end

  context 'when value is nil' do
    let(:value) { nil }
    it 'renders empty input' do
      expect(rendered).to eq "<div class=\"form-group \">\n  <label for=\"all_postgres_type_money\">Money</label>\n  <div class=\"row\">\n    <div class=\"col-xs-6 col-sm-3\">\n      <div class=\"input-group\">\n        <span class=\"input-group-addon\">$</span>\n        <input class=\"form-control\" type=\"text\" name=\"all_postgres_type[money]\" id=\"all_postgres_type_money\" />\n      </div>\n    </div>\n  </div>\n  \n</div>\n"
    end
  end
end
