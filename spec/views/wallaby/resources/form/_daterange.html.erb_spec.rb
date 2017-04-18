require 'rails_helper'

partial_name = 'form/daterange'
describe partial_name do
  let(:partial)     { "wallaby/resources/#{partial_name}.html.erb" }
  let(:form)        { Wallaby::FormBuilder.new object.model_name.param_key, object, view, {} }
  let(:object)      { AllPostgresType.new field_name => value }
  let(:field_name)  { :daterange }
  let(:value)       { Date.new(2014, 2, 11)..Date.new(2014, 3, 14) }
  let(:metadata)    { {} }

  before do
    expect(view).to receive :content_for
    render partial, form: form, object: object, field_name: field_name, value: value, metadata: metadata
  end

  it 'renders the daterange form' do
    expect(rendered).to eq "<div class=\"form-group \">\n  <label for=\"all_postgres_type_daterange\">Daterange</label>\n  <div class=\"row\">\n    <div class=\"col-xs-6 col-sm-3\">\n      <div class=\"input-group date\" data-init='datepicker'>\n        <span class=\"input-group-addon\">F</span>\n        <input value=\"2014-02-11\" multiple=\"multiple\" class=\"form-control\" type=\"text\" name=\"all_postgres_type[daterange][]\" id=\"all_postgres_type_daterange\" />\n        <span class=\"input-group-addon\"><i class=\"glyphicon glyphicon-calendar\"></i></span>\n      </div>\n    </div>\n    <div class=\"col-xs-6 col-sm-3\">\n      <div class=\"input-group date\" data-init='datepicker'>\n        <span class=\"input-group-addon\">T</span>\n        <input value=\"2014-03-14\" multiple=\"multiple\" class=\"form-control\" type=\"text\" name=\"all_postgres_type[daterange][]\" id=\"all_postgres_type_daterange\" />\n        <span class=\"input-group-addon\"><i class=\"glyphicon glyphicon-calendar\"></i></span>\n      </div>\n    </div>\n  </div>\n  \n</div>\n\n"
  end

  context 'when value is nil' do
    let(:value) { nil }
    it 'renders empty input' do
      expect(rendered).to eq "<div class=\"form-group \">\n  <label for=\"all_postgres_type_daterange\">Daterange</label>\n  <div class=\"row\">\n    <div class=\"col-xs-6 col-sm-3\">\n      <div class=\"input-group date\" data-init='datepicker'>\n        <span class=\"input-group-addon\">F</span>\n        <input multiple=\"multiple\" class=\"form-control\" type=\"text\" name=\"all_postgres_type[daterange][]\" id=\"all_postgres_type_daterange\" />\n        <span class=\"input-group-addon\"><i class=\"glyphicon glyphicon-calendar\"></i></span>\n      </div>\n    </div>\n    <div class=\"col-xs-6 col-sm-3\">\n      <div class=\"input-group date\" data-init='datepicker'>\n        <span class=\"input-group-addon\">T</span>\n        <input multiple=\"multiple\" class=\"form-control\" type=\"text\" name=\"all_postgres_type[daterange][]\" id=\"all_postgres_type_daterange\" />\n        <span class=\"input-group-addon\"><i class=\"glyphicon glyphicon-calendar\"></i></span>\n      </div>\n    </div>\n  </div>\n  \n</div>\n\n"
    end
  end
end
