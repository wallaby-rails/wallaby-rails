require 'rails_helper'

partial_name = 'show/binary'
describe partial_name do
  let(:partial)   { "wallaby/resources/#{partial_name}.html.erb" }
  let(:value)     { double }
  let(:metadata)  { {} }

  before { render partial, value: value, metadata: metadata }

  it 'renders na' do
    expect(rendered).to include view.na
  end

  context 'when value is nil' do
    let(:value) { nil }
    it 'renders null' do
      expect(rendered).to include view.null
    end
  end
end
