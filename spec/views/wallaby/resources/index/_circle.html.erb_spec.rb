require 'rails_helper'

partial_name = 'index/circle'
describe partial_name do
  let(:partial) { "wallaby/resources/#{partial_name}.html.erb" }
  let(:value) { resource.circle }
  let(:resource) { AllPostgresType.new circle: '<(1,2),5>' }
  let(:metadata) { { label: 'Circle' } }

  before { render partial, value: value, metadata: metadata }

  it 'renders the circle' do
    expect(rendered).to include '<code>&lt;(1,2),5&gt;</code>'
  end

  context 'when value is larger than 20' do
    let(:resource) { AllPostgresType.new circle: '<(1.0000008,2.00000008),5.00000008>' }

    it 'renders the circle' do
      expect(rendered).to include '<code>&lt;(1.0000008,2.000...</code>'
      expect(rendered).to include 'title="&lt;(1.0000008,2.00000008),5.00000008&gt;"'
    end
  end

  context 'when value is nil' do
    let(:value) { nil }
    it 'renders null' do
      expect(rendered).to include view.null
    end
  end
end
