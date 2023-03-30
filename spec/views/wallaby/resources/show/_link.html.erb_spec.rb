# frozen_string_literal: true

require 'rails_helper'

partial_name = 'show/link'
describe partial_name, :wallaby_user do
  let(:partial)   { "wallaby/resources/#{partial_name}" }
  let(:value)     { 'https://reinteractive.com/' }
  let(:metadata)  { { title: 'Rails Developers', html_options: { target: '_blank' } } }

  before do
    render partial, value: value, metadata: metadata
  end

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
