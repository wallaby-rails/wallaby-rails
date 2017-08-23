require 'rails_helper'

partial_name = 'index/email'
describe partial_name do
  let(:partial)   { "wallaby/resources/#{partial_name}.html.erb" }
  let(:value)     { 'tian@reinteractive.net' }
  let(:metadata)  { {} }

  before { render partial, value: value, metadata: metadata }

  it 'renders the email' do
    expect(rendered).to eq "<a href=\"mailto:tian@reinteractive.net\">tian@reinteractive.net</a>\n"
  end

  context 'when value is nil' do
    let(:value) { nil }
    it 'renders null' do
      expect(rendered).to include view.null
    end
  end
end
