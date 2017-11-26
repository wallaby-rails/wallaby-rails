require 'rails_helper'

partial_name = 'show/image'
describe partial_name do
  let(:partial)   { "wallaby/resources/#{partial_name}.html.erb" }
  let(:value)     { '/upload/logo.jpg' }
  let(:metadata)  { {} }

  before { render partial, value: value, metadata: metadata }

  it 'renders the image' do
    expect(rendered).to include value
  end

  context 'when value is nil' do
    let(:value) { nil }
    it 'renders null' do
      expect(rendered).to include view.null
    end
  end
end
