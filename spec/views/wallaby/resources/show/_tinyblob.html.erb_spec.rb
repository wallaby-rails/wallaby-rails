require 'rails_helper'

partial_name = 'show/tinyblob'
describe partial_name do
  let(:partial)   { "wallaby/resources/#{partial_name}.html.erb" }
  let(:value)     { '010111' }
  let(:metadata)  { {} }

  before { render partial, value: value, metadata: metadata }

  it 'renders <tinyblob>' do
    expect(rendered).to include view.muted('tinyblob')
  end

  context 'when value is nil' do
    let(:value) { nil }

    it 'renders null' do
      expect(rendered).to include view.null
    end
  end
end
