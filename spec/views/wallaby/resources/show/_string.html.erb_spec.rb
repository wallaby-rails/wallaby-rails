require 'rails_helper'

partial_name = 'show/string'
describe partial_name do
  let(:partial)   { "wallaby/resources/#{partial_name}.html.erb" }
  let(:value)     { 'this is a text for more than 20 characters' }
  let(:metadata)  { {} }

  before { render partial, value: value, metadata: metadata }

  it 'renders the string' do
    expect(rendered).to eq "this is a text for more than 20 characters\n"
  end

  context 'when value is nil' do
    let(:value) { nil }
    it 'renders null' do
      expect(rendered).to include view.null
    end
  end
end
