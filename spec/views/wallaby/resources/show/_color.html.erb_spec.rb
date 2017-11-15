require 'rails_helper'

partial_name = 'show/color'
describe partial_name do
  let(:partial)   { "wallaby/resources/#{partial_name}.html.erb" }
  let(:value)     { '#000000' }
  let(:metadata)  { {} }

  before { render partial, value: value, metadata: metadata }

  it 'renders the string' do
    expect(rendered).to include "background-color: #{value};"
    expect(rendered).to include "<span class=\"text-uppercase\">#{value}</span>"
  end

  context 'when value is nil' do
    let(:value) { nil }
    it 'renders null' do
      expect(rendered).to include view.null
    end
  end
end
