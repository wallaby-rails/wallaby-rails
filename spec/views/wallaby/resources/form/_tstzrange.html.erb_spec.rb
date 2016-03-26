require 'rails_helper'

describe 'partial' do
  let(:partial)     { "wallaby/resources/form/#{ field_name }.html.erb" }
  let(:form)        { Wallaby::FormBuilder.new object.model_name.param_key, object, view, { } }
  let(:object)      { AllPostgresType.new field_name => value }
  let(:field_name)  { :tstzrange }
  let(:value)       { Time.zone.parse('2016-03-16 14:55:10 UTC')..Time.zone.parse('2016-03-18 14:55:10 UTC') }
  let(:metadata)    { Hash.new }

  before do
    expect(view).to receive :content_for
    render partial, form: form, object: object, field_name: field_name, value: value, metadata: metadata
  end

  it 'renders the tstzrange form' do
    expect(rendered).to eq "<div class=\"form-group \">\n  <label for=\"all_postgres_type_tstzrange\">Tstzrange</label>\n  <div class=\"row\">\n    <div class=\"col-xs-6 col-sm-3\">\n      <div class=\"input-group date\" data-init='datetimepicker'>\n        <span class=\"input-group-addon\">F</span>\n        <input value=\"2016-03-16 14:55:10 UTC\" multiple=\"multiple\" class=\"form-control\" type=\"text\" name=\"all_postgres_type[tstzrange][]\" id=\"all_postgres_type_tstzrange\" />\n        <span class=\"input-group-addon\"><i class=\"glyphicon glyphicon-calendar\"></i></span>\n      </div>\n    </div>\n    <div class=\"col-xs-6 col-sm-3\">\n      <div class=\"input-group date\" data-init='datetimepicker'>\n        <span class=\"input-group-addon\">T</span>\n        <input value=\"2016-03-18 14:55:10 UTC\" multiple=\"multiple\" class=\"form-control\" type=\"text\" name=\"all_postgres_type[tstzrange][]\" id=\"all_postgres_type_tstzrange\" />\n        <span class=\"input-group-addon\"><i class=\"glyphicon glyphicon-calendar\"></i></span>\n      </div>\n    </div>\n  </div>\n  \n</div>\n\n"
  end

  context 'when value is nil' do
    let(:value) { nil }
    it 'renders empty input' do
      expect(rendered).to eq "<div class=\"form-group \">\n  <label for=\"all_postgres_type_tstzrange\">Tstzrange</label>\n  <div class=\"row\">\n    <div class=\"col-xs-6 col-sm-3\">\n      <div class=\"input-group date\" data-init='datetimepicker'>\n        <span class=\"input-group-addon\">F</span>\n        <input multiple=\"multiple\" class=\"form-control\" type=\"text\" name=\"all_postgres_type[tstzrange][]\" id=\"all_postgres_type_tstzrange\" />\n        <span class=\"input-group-addon\"><i class=\"glyphicon glyphicon-calendar\"></i></span>\n      </div>\n    </div>\n    <div class=\"col-xs-6 col-sm-3\">\n      <div class=\"input-group date\" data-init='datetimepicker'>\n        <span class=\"input-group-addon\">T</span>\n        <input multiple=\"multiple\" class=\"form-control\" type=\"text\" name=\"all_postgres_type[tstzrange][]\" id=\"all_postgres_type_tstzrange\" />\n        <span class=\"input-group-addon\"><i class=\"glyphicon glyphicon-calendar\"></i></span>\n      </div>\n    </div>\n  </div>\n  \n</div>\n\n"
    end
  end
end
