require 'rails_helper'

partial_name = 'form/tsvector'
describe partial_name do
  let(:partial)     { "wallaby/resources/#{ partial_name }.html.erb" }
  let(:form)        { Wallaby::FormBuilder.new object.model_name.param_key, object, view, { } }
  let(:object)      { AllPostgresType.new field_name => value }
  let(:field_name)  { :tsvector }
  let(:value)       { "'a' 'and' 'ate' 'cat' 'fat' 'mat' 'on' 'rat' 'sat'" }
  let(:metadata)    { {} }

  before { render partial, form: form, object: object, field_name: field_name, value: value, metadata: metadata }

  it 'renders the tsvector form' do
    expect(rendered).to eq "<div class=\"form-group \">\n  <label for=\"all_postgres_type_tsvector\">Tsvector</label>\n  <textarea class=\"form-control\" name=\"all_postgres_type[tsvector]\" id=\"all_postgres_type_tsvector\">\n&#39;a&#39; &#39;and&#39; &#39;ate&#39; &#39;cat&#39; &#39;fat&#39; &#39;mat&#39; &#39;on&#39; &#39;rat&#39; &#39;sat&#39;</textarea>\n  \n</div>\n"
  end

  context 'when value is nil' do
    let(:value) { nil }
    it 'renders empty input' do
      expect(rendered).to eq "<div class=\"form-group \">\n  <label for=\"all_postgres_type_tsvector\">Tsvector</label>\n  <textarea class=\"form-control\" name=\"all_postgres_type[tsvector]\" id=\"all_postgres_type_tsvector\">\n</textarea>\n  \n</div>\n"
    end
  end
end
