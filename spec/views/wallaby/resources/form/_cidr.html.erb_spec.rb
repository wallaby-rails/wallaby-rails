require 'rails_helper'

describe 'partial' do
  let(:partial)     { "wallaby/resources/form/#{ field_name }.html.erb" }
  let(:form)        { Wallaby::FormBuilder.new object.model_name.param_key, object, view, { } }
  let(:object)      { AllPostgresType.new field_name => value }
  let(:field_name)  { :cidr }
  let(:value)       { IPAddr.new '192.168.2.0/24' }
  let(:metadata)    { Hash.new }

  before { render partial, form: form, object: object, field_name: field_name, value: value, metadata: metadata }

  it 'renders the cidr form and ticks yes' do
    expect(rendered).to eq "<div class=\"form-group \">\n  <label for=\"all_postgres_type_cidr\">Cidr</label>\n  <div class=\"row\">\n    <div class=\"col-xs-6 col-sm-3\">\n      <input class=\"form-control\" type=\"text\" value=\"192.168.2.0\" name=\"all_postgres_type[cidr]\" id=\"all_postgres_type_cidr\" />\n    </div>\n  </div>\n  \n</div>\n"
  end

  context 'when value is nil' do
    let(:value) { nil }
    it 'renders the cidr form and ticks nothing' do
      expect(rendered).to eq "<div class=\"form-group \">\n  <label for=\"all_postgres_type_cidr\">Cidr</label>\n  <div class=\"row\">\n    <div class=\"col-xs-6 col-sm-3\">\n      <input class=\"form-control\" type=\"text\" name=\"all_postgres_type[cidr]\" id=\"all_postgres_type_cidr\" />\n    </div>\n  </div>\n  \n</div>\n"
    end
  end
end
