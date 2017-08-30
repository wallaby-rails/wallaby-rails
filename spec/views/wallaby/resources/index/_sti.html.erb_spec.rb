require 'rails_helper'

partial_name = 'index/sti'
describe partial_name do
  let(:partial)   { "wallaby/resources/#{partial_name}.html.erb" }
  let(:value)     { 'Wallaby::ActiveRecord::ExampleClass' }
  let(:metadata)  { { label: 'Sti' } }

  before { render partial, value: value, metadata: metadata }

  it 'renders the sti' do
    expect(rendered).to include '<span>Wallaby::ActiveRe...</span>'
    expect(rendered).to include "title=\"#{value}\""
  end

  context 'when value is less than 20 characters' do
    let(:value) { 'Wallaby' }
    it 'renders the sti' do
      expect(rendered).to include value
    end
  end

  context 'when max is set to 50' do
    let(:metadata)  { Hash max: 50 }
    it 'renders the sti' do
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
