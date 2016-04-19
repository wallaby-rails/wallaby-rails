require 'rails_helper'

partial_name = 'form/inet'
describe partial_name do
  let(:partial)   { "wallaby/resources/#{ partial_name }.html.erb" }
  let(:form)        { Wallaby::FormBuilder.new object.model_name.param_key, object, view, { } }
  let(:object)      { AllPostgresType.new field_name => value }
  let(:field_name)  { :inet }
  let(:value)       { IPAddr.new '192.168.1.12' }
  let(:metadata)    { Hash.new }

  before { render partial, form: form, object: object, field_name: field_name, value: value, metadata: metadata }

  it 'renders the inet form' do
    expect(rendered).to eq "<div class=\"form-group \">\n  <label for=\"all_postgres_type_inet\">Inet</label>\n  <div class=\"row\">\n    <div class=\"col-xs-6 col-sm-3\">\n      <input class=\"form-control\" type=\"text\" value=\"192.168.1.12\" name=\"all_postgres_type[inet]\" id=\"all_postgres_type_inet\" />\n    </div>\n  </div>\n  \n</div>\n"
  end

  context 'when value is nil' do
    let(:value) { nil }
    it 'renders empty input' do
      expect(rendered).to eq "<div class=\"form-group \">\n  <label for=\"all_postgres_type_inet\">Inet</label>\n  <div class=\"row\">\n    <div class=\"col-xs-6 col-sm-3\">\n      <input class=\"form-control\" type=\"text\" name=\"all_postgres_type[inet]\" id=\"all_postgres_type_inet\" />\n    </div>\n  </div>\n  \n</div>\n"
    end
  end
end
