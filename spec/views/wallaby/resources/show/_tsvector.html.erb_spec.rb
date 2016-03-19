require 'rails_helper'

describe 'partial' do
  let(:partial)   { 'wallaby/resources/show/tsvector.html.erb' }
  let(:value)     { "'a' 'and' 'ate' 'cat' 'fat' 'mat' 'on' 'rat' 'sat'" }
  let(:metadata)  { Hash.new }

  before { render partial, value: value, metadata: metadata }

  it 'renders the tsvector' do
    expect(rendered).to eq "&#39;a&#39; &#39;and&#39; &#39;ate&#39; &#39;cat&#39; &#39;fat&#39; &#39;mat&#39; &#39;on&#39; &#39;rat&#39; &#39;sat&#39;\n"
  end

  context 'when value is nil' do
    let(:value) { nil }
    it 'renders null' do
      expect(rendered).to eq "<i class=\"text-muted\">&lt;null&gt;</i>\n"
    end
  end
end
