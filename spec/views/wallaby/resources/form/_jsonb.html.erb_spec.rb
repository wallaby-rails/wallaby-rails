require 'rails_helper'

partial_name = 'form/jsonb'
describe partial_name do
  let(:partial)     { "wallaby/resources/#{partial_name}.html.erb" }
  let(:form)        { Wallaby::FormBuilder.new object.model_name.param_key, object, view, {} }
  let(:object)      { AllPostgresType.new field_name => value }
  let(:field_name)  { :jsonb }
  let(:metadata)    { {} }
  let(:value) do
    {
      'kind' => 'user_renamed',
      'change' => %w(jack john)
    }
  end

  before do
    expect(view).to receive :content_for
    render partial, form: form, object: object, field_name: field_name, value: value, metadata: metadata
  end

  it 'renders the jsonb form' do
    expect(rendered).to eq "<div class=\"form-group \">\n  <label for=\"all_postgres_type_jsonb\">Jsonb</label>\n  <textarea class=\"form-control\" data-init=\"codemirror\" data-mode=\"javascript\" name=\"all_postgres_type[jsonb]\" id=\"all_postgres_type_jsonb\">\n{\n  &quot;kind&quot;: &quot;user_renamed&quot;,\n  &quot;change&quot;: [\n    &quot;jack&quot;,\n    &quot;john&quot;\n  ]\n}</textarea>\n  \n</div>\n\n"
  end

  context 'when value is nil' do
    let(:value) { nil }
    it 'renders empty input' do
      expect(rendered).to eq "<div class=\"form-group \">\n  <label for=\"all_postgres_type_jsonb\">Jsonb</label>\n  <textarea class=\"form-control\" data-init=\"codemirror\" data-mode=\"javascript\" name=\"all_postgres_type[jsonb]\" id=\"all_postgres_type_jsonb\">\nnull</textarea>\n  \n</div>\n\n"
    end
  end
end
