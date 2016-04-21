require 'rails_helper'

partial_name = 'form/binary'
describe partial_name do
  let(:partial)     { "wallaby/resources/#{ partial_name }.html.erb" }
  let(:form)        { Wallaby::FormBuilder.new object.model_name.param_key, object, view, { } }
  let(:object)      { AllPostgresType.new field_name => value }
  let(:field_name)  { :binary }
  let(:value)       { 'Binary string' }
  let(:metadata)    { Hash.new }

  before { render partial, form: form, object: object, field_name: field_name, value: value, metadata: metadata }

  it 'renders the binary form' do
    expect(rendered).to eq "<div class=\"form-group \">\n  <label for=\"all_postgres_type_binary\">Binary</label>\n  <div class=\"row\">\n    <div class=\"col-xs-3\">\n      <label class=\"btn btn-default\" for=\"all_postgres_type_binary\">\n        <input class=\"hidden\" type=\"file\" name=\"all_postgres_type[binary]\" id=\"all_postgres_type_binary\" />\n        <i class=\"glyphicon glyphicon-upload\"></i> Upload\n</label>    </div>\n  </div>\n  \n</div>\n"
  end

  context 'when value is nil' do
    let(:value) { nil }
    it 'renders empty input' do
      expect(rendered).to eq "<div class=\"form-group \">\n  <label for=\"all_postgres_type_binary\">Binary</label>\n  <div class=\"row\">\n    <div class=\"col-xs-3\">\n      <label class=\"btn btn-default\" for=\"all_postgres_type_binary\">\n        <input class=\"hidden\" type=\"file\" name=\"all_postgres_type[binary]\" id=\"all_postgres_type_binary\" />\n        <i class=\"glyphicon glyphicon-upload\"></i> Upload\n</label>    </div>\n  </div>\n  \n</div>\n"
    end
  end
end
