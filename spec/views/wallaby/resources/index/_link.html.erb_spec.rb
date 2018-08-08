require 'rails_helper'

partial_name = 'index/link'
describe partial_name, :current_user do
  let(:partial)   { "wallaby/resources/#{partial_name}.html.erb" }
  let(:value)     { 'https://reinteractive.com/' }
  let(:metadata)  { { label: 'Rails Developers', html_options: { target: '_blank' } } }

  before { render partial, value: value, metadata: metadata }

  it 'renders the link' do
    expect(rendered).to include '<a target="_blank" href="https://reinteractive.com/">Rails Developers</a>'
  end
end
