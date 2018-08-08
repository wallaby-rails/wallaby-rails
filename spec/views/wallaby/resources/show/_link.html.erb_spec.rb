require 'rails_helper'

partial_name = 'show/link'
describe partial_name, :current_user do
  let(:partial)   { "wallaby/resources/#{partial_name}.html.erb" }
  let(:value)     { 'https://reinteractive.com/' }
  let(:metadata)  { { title: 'Rails Developers', html_options: { target: '_blank' } } }

  before { render partial, value: value, metadata: metadata }

  it 'renders the belongs_to' do
    expect(rendered).to include '<a target="_blank" href="https://reinteractive.com/">Rails Developers</a>'
  end

  context 'when value is nil' do
    let(:value) { nil }
    it 'renders null' do
      expect(rendered).to include view.null
    end
  end
end
