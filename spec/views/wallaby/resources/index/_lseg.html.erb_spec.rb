require 'rails_helper'

partial_name = 'index/lseg'
describe partial_name do
  let(:partial) { "wallaby/resources/#{partial_name}.html.erb" }
  let(:value) { resource.lseg }
  let(:resource) { AllPostgresType.new lseg: '[(1,2),(3,4)]' }
  let(:metadata) { { label: 'Lseg' } }

  before { render partial, value: value, metadata: metadata }

  it 'renders the lseg' do
    expect(rendered).to include "<code>#{value}</code>"
  end

  context 'when value is larger than 20' do
    let(:resource) { AllPostgresType.new lseg: '[(1.0000008,2.0000008),(3.0000008,4.0000008)]' }

    it 'renders the lseg' do
      expect(rendered).to include '<code>[(1.0000008,2.000...</code>'
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
