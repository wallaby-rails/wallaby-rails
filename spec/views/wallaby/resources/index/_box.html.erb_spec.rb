require 'rails_helper'

partial_name = 'index/box'
describe partial_name do
  let(:partial) { "wallaby/resources/#{partial_name}.html.erb" }
  let(:value) { resource.box }
  let(:resource) { AllPostgresType.new box: '(1,2),(3,4)' }
  let(:metadata) { { label: 'Box' } }

  before { render partial, value: value, metadata: metadata }

  it 'renders the box' do
    expect(rendered).to include '<code>(1,2),(3,4)</code>'
  end

  context 'when value is larger than 20' do
    let(:resource) { AllPostgresType.new box: '(1.0000008,2.00000008),(3.99999999,4.5555555555)' }

    it 'renders the box' do
      expect(rendered).to include '<code>(1.0000008,2.0000...</code>'
      expect(rendered).to include "title=\"#{value}\""
    end
  end

  context 'when value is nil' do
    let(:value) { nil }
    it 'renders null' do
      expect(rendered).to include view.null
    end
  end
end
