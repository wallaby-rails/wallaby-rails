require 'rails_helper'

partial_name = 'form/bigint'
describe partial_name do
  let(:partial)     { "wallaby/resources/#{partial_name}.html.erb" }
  let(:partial)     { "wallaby/resources/form/#{field_name}.html.erb" }
  let(:form)        { Wallaby::FormBuilder.new object.model_name.param_key, object, view, {} }
  let(:object)      { AllPostgresType.new field_name => value }
  let(:field_name)  { :bigint }
  let(:value)       { BigDecimal.new(42)**20 }
  let(:metadata)    { {} }

  before { render partial, form: form, object: object, field_name: field_name, value: value, metadata: metadata }

  it 'renders the bigint form' do
    expect(rendered).to eq "<div class=\"form-group \">\n  <label for=\"all_postgres_type_bigint\">Bigint</label>\n  <div class=\"row\">\n    <div class=\"col-xs-6 col-sm-3\">\n      <input class=\"form-control\" type=\"number\" value=\"291733167875766667063796853374976.0\" name=\"all_postgres_type[bigint]\" id=\"all_postgres_type_bigint\" />\n    </div>\n  </div>\n  \n</div>\n"
  end

  context 'when value is nil' do
    let(:value) { nil }
    it 'renders empty input' do
      expect(rendered).to eq "<div class=\"form-group \">\n  <label for=\"all_postgres_type_bigint\">Bigint</label>\n  <div class=\"row\">\n    <div class=\"col-xs-6 col-sm-3\">\n      <input class=\"form-control\" type=\"number\" name=\"all_postgres_type[bigint]\" id=\"all_postgres_type_bigint\" />\n    </div>\n  </div>\n  \n</div>\n"
    end
  end
end
