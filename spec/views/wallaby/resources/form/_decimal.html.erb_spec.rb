require 'rails_helper'

describe 'partial' do
  let(:partial)     { "wallaby/resources/form/#{ field_name }.html.erb" }
  let(:form)        { Wallaby::FormBuilder.new object.model_name.param_key, object, view, { } }
  let(:object)      { AllPostgresType.new field_name => value }
  let(:field_name)  { :decimal }
  let(:value)       { BigDecimal.new(42)**13 / 10**20 }
  let(:metadata)    { Hash.new }

  before { render partial, form: form, object: object, field_name: field_name, value: value, metadata: metadata }

  it 'renders the decimal form' do
    expect(rendered).to eq "<div class=\"form-group \">\n  <label for=\"all_postgres_type_decimal\">Decimal</label>\n  <div class=\"row\">\n    <div class=\"col-xs-6 col-sm-3\">\n      <input class=\"form-control\" type=\"number\" value=\"12.65437718438866624512\" name=\"all_postgres_type[decimal]\" id=\"all_postgres_type_decimal\" />\n    </div>\n  </div>\n  \n</div>\n"
  end

  context 'when value is nil' do
    let(:value) { nil }
    it 'renders empty input' do
      expect(rendered).to eq "<div class=\"form-group \">\n  <label for=\"all_postgres_type_decimal\">Decimal</label>\n  <div class=\"row\">\n    <div class=\"col-xs-6 col-sm-3\">\n      <input class=\"form-control\" type=\"number\" name=\"all_postgres_type[decimal]\" id=\"all_postgres_type_decimal\" />\n    </div>\n  </div>\n  \n</div>\n"
    end
  end
end
