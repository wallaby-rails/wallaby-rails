require 'rails_helper'

partial_name = 'show/money'
describe partial_name do
  let(:partial)   { "wallaby/resources/#{partial_name}.html.erb" }
  let(:value)     { 100.88 }
  let(:metadata)  { {} }

  before { render partial, value: value, metadata: metadata }

  it 'renders the money' do
    expect(rendered).to include value.to_s
  end

  context 'when value is 0' do
    let(:value) { 0 }

    it 'renders the money' do
      expect(rendered).to include value.to_s
    end
  end

  context 'when value is nil' do
    let(:value) { nil }

    it 'renders null' do
      expect(rendered).to include view.null
    end
  end
end
