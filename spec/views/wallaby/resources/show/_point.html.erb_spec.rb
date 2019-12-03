require 'rails_helper'

partial_name = 'show/point'
describe partial_name do
  let(:partial)   { "wallaby/resources/#{partial_name}.html.erb" }
  let(:value)     { [3, 4] }
  let(:metadata)  { {} }

  before { render partial, value: value, metadata: metadata }

  it 'renders the point' do
    expect(rendered).to eq "  (<span class=\"x\">3</span>,\n  <span class=\"y\">4</span>)\n"
  end

  context 'when value is nil' do
    let(:value) { nil }

    it 'renders null' do
      expect(rendered).to include view.null
    end
  end
end
