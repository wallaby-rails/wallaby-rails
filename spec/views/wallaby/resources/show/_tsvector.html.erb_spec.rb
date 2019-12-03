require 'rails_helper'

partial_name = 'show/tsvector'
describe partial_name do
  let(:partial)   { "wallaby/resources/#{partial_name}.html.erb" }
  let(:value)     { "'a' 'and' 'ate' 'cat' 'fat' 'mat' 'on' 'rat' 'sat'" }
  let(:metadata)  { {} }

  before { render partial, value: value, metadata: metadata }

  it 'renders the tsvector' do
    expect(rendered).to include h(value)
  end

  context 'when value is nil' do
    let(:value) { nil }

    it 'renders null' do
      expect(rendered).to include view.null
    end
  end
end
