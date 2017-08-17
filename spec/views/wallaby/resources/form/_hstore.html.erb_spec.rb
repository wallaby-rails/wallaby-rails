require 'rails_helper'

partial_name = 'form/hstore'
describe partial_name do
  let(:partial)     { "wallaby/resources/#{partial_name}.html.erb" }
  let(:form)        { Wallaby::FormBuilder.new object.model_name.param_key, object, view, {} }
  let(:object)      { AllPostgresType.new field_name => value }
  let(:field_name)  { :hstore }
  let(:value)       { { 'key' => 'very long text' } }
  let(:metadata)    { {} }

  before do
    expect(view).to receive :content_for
    render partial, form: form, object: object, field_name: field_name, value: value, metadata: metadata
  end

  it 'renders the hstore form' do
    expect(rendered).to eq "<div class=\"form-group \">\n  <label for=\"all_postgres_type_hstore\">Hstore</label>\n  <textarea class=\"form-control\" data-init=\"codemirror\" data-mode=\"ruby\" name=\"all_postgres_type[hstore]\" id=\"all_postgres_type_hstore\">\n&quot;key&quot;=&gt;&quot;very long text&quot;</textarea>\n  \n</div>\n<p class=\"help-block\">\n  Format: <code>\"KEY1\" => \"VALUE1\", \"KEY2\" => \"VALUE2\"</code>\n</p>\n\n"
  end

  context 'when value is nil' do
    let(:value) { nil }
    it 'renders empty input' do
      expect(rendered).to eq "<div class=\"form-group \">\n  <label for=\"all_postgres_type_hstore\">Hstore</label>\n  <textarea class=\"form-control\" data-init=\"codemirror\" data-mode=\"ruby\" name=\"all_postgres_type[hstore]\" id=\"all_postgres_type_hstore\">\n</textarea>\n  \n</div>\n<p class=\"help-block\">\n  Format: <code>\"KEY1\" => \"VALUE1\", \"KEY2\" => \"VALUE2\"</code>\n</p>\n\n"
    end
  end
end
