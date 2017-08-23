require 'rails_helper'

partial_name = 'show/tsvector'
describe partial_name do
  let(:partial)   { "wallaby/resources/#{partial_name}.html.erb" }
  let(:value)     { "'a' 'and' 'ate' 'cat' 'fat' 'mat' 'on' 'rat' 'sat'" }
  let(:metadata)  { {} }

  before { render partial, value: value, metadata: metadata }

  it 'renders the tsvector' do
    expect(rendered).to eq "&#39;a&#39; &#39;and&#39; &#39;ate&#39; &#39;cat&#39; &#39;fat&#39; &#39;mat&#39; &#39;on&#39; &#39;rat&#39; &#39;sat&#39;\n"
  end

  context 'when value is nil' do
    let(:value) { nil }
    it 'renders null' do
      expect(rendered).to include view.null
    end
  end
end
