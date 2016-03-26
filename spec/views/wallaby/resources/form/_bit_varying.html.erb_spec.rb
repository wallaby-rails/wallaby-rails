require 'rails_helper'

describe 'partial' do
  let(:partial)     { "wallaby/resources/form/#{ field_name }.html.erb" }
  let(:form)        { Wallaby::FormBuilder.new object.model_name.param_key, object, view, { } }
  let(:object)      { AllPostgresType.new field_name => value }
  let(:field_name)  { :bit_varying }
  let(:value)       { "11010100" }
  let(:metadata)    { Hash.new }

  before { render partial, form: form, object: object, field_name: field_name, value: value, metadata: metadata }

  it 'renders the bit_varying form' do
    expect(rendered).to eq "<div class=\"form-group \">\n  <label for=\"all_postgres_type_bit_varying\">Bit varying</label>\n  <div class=\"row\">\n    <div class=\"col-xs-6 col-sm-3\">\n      <input class=\"form-control\" type=\"number\" value=\"11010100\" name=\"all_postgres_type[bit_varying]\" id=\"all_postgres_type_bit_varying\" />\n    </div>\n  </div>\n  \n</div>\n"
  end

  context 'when value is nil' do
    let(:value) { nil }
    it 'renders empty input' do
      expect(rendered).to eq "<div class=\"form-group \">\n  <label for=\"all_postgres_type_bit_varying\">Bit varying</label>\n  <div class=\"row\">\n    <div class=\"col-xs-6 col-sm-3\">\n      <input class=\"form-control\" type=\"number\" name=\"all_postgres_type[bit_varying]\" id=\"all_postgres_type_bit_varying\" />\n    </div>\n  </div>\n  \n</div>\n"
    end
  end
end
