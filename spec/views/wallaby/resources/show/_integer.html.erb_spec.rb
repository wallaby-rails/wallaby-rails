require 'rails_helper'

partial_name = 'show/integer'
describe partial_name do
  let(:partial)   { "wallaby/resources/#{partial_name}.html.erb" }
  let(:value)     { 100 }
  let(:metadata)  { {} }

  before { render partial, value: value, metadata: metadata }

  it 'renders the integer' do
    expect(rendered).to eq "100\n"
  end

  context 'when value is 0' do
    let(:value) { 0 }
    it 'renders the integer' do
      expect(rendered).to eq "0\n"
    end
  end

  context 'when value is nil' do
    let(:value) { nil }
    it 'renders null' do
      expect(rendered).to include view.null
    end
  end
end
