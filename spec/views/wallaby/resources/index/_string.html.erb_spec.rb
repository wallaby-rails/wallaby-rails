require 'rails_helper'

partial_name = 'index/string'
describe partial_name do
  let(:partial)   { "wallaby/resources/#{partial_name}.html.erb" }
  let(:value)     { 'this is a text for more than 20 characters' }
  let(:metadata)  { {} }

  before { render partial, value: value, metadata: metadata }

  it 'renders the string' do
    expect(rendered).to include '<span>this is a text fo...</span>'
    expect(rendered).to include "title=\"#{value}\""
  end

  context 'when value is less than 20 characters' do
    let(:value) { '12345678901234567890' }
    it 'renders the string' do
      expect(rendered).to include value
    end
  end

  context 'when max is set to 50' do
    let(:metadata)  { Hash max: 50 }
    it 'renders the string' do
      expect(rendered).to include value
    end
  end

  context 'when value is nil' do
    let(:value) { nil }
    it 'renders null' do
      expect(rendered).to include view.null
    end
  end
end
