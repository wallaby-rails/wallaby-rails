require 'rails_helper'

partial_name = 'index/path'
describe partial_name do
  let(:partial) { "wallaby/resources/#{partial_name}.html.erb" }
  let(:page) { Nokogiri::HTML rendered }
  let(:value) { resource.path }
  let(:resource) { AllPostgresType.new path: '((1,2),(3,4))' }
  let(:metadata) { { label: 'Path' } }

  before { render partial, value: value, metadata: metadata }

  it 'renders the path' do
    expect(rendered).to include "<code>#{value}</code>"
  end

  context 'when value is larger than 20' do
    let(:resource) { AllPostgresType.new path: '((1.0000008,2.0000008),(3.0000008,4.0000008))' }

    it 'renders the path' do
      expect(rendered).to include '<code>((1.0000008,2.000...</code>'
      expect(page.at_css('.modaler__body').content).to include value
    end
  end

  context 'when value is nil' do
    let(:value) { nil }
    it 'renders null' do
      expect(rendered).to include view.null
    end
  end
end
