require 'rails_helper'

partial_name = 'form/float'
describe partial_name do
  let(:partial)     { "wallaby/resources/#{partial_name}.html.erb" }
  let(:form)        { Wallaby::FormBuilder.new object.model_name.param_key, object, view, {} }
  let(:object)      { AllPostgresType.new field_name => value }
  let(:field_name)  { :float }
  let(:value)       { 88.8888 }
  let(:metadata)    { {} }

  before { render partial, form: form, object: object, field_name: field_name, value: value, metadata: metadata }

  it 'renders the float form' do
    expect(rendered).to eq "<div class=\"form-group \">\n  <label for=\"all_postgres_type_float\">Float</label>\n  <div class=\"row\">\n    <div class=\"col-xs-6 col-sm-4\">\n      <input class=\"form-control\" type=\"number\" value=\"88.8888\" name=\"all_postgres_type[float]\" id=\"all_postgres_type_float\" />\n    </div>\n  </div>\n  \n</div>\n"
  end

  context 'when value is nil' do
    let(:value) { nil }
    it 'renders empty input' do
      expect(rendered).to eq "<div class=\"form-group \">\n  <label for=\"all_postgres_type_float\">Float</label>\n  <div class=\"row\">\n    <div class=\"col-xs-6 col-sm-4\">\n      <input class=\"form-control\" type=\"number\" name=\"all_postgres_type[float]\" id=\"all_postgres_type_float\" />\n    </div>\n  </div>\n  \n</div>\n"
    end
  end
end
