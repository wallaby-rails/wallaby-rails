require 'rails_helper'

partial_name = 'show/line'
describe partial_name do
  let(:partial) { "wallaby/resources/#{partial_name}.html.erb" }
  let(:value) { resource.line }
  let(:resource) { AllPostgresType.new line: '{1,2,5}' }
  let(:metadata) { { label: 'Line' } }

  before { render partial, value: value, metadata: metadata }

  it 'renders the line' do
    expect(rendered).to include "<code>#{value}</code>"
  end

  context 'when value is nil' do
    let(:value) { nil }

    it 'renders null' do
      expect(rendered).to include view.null
    end
  end
end
