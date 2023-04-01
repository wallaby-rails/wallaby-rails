# frozen_string_literal: true

require 'rails_helper'

partial_name = 'show/text'
describe partial_name do
  let(:partial)   { "wallaby/resources/#{partial_name}" }
  let(:value)     { '<b>this is a text for more than 20 characters</b>' }
  let(:metadata)  { {} }

  before do
    render partial, value: value, metadata: metadata
  end

  it 'renders the text' do
    expect(rendered).to include h(value)
  end

  context 'when value is nil' do
    let(:value) { nil }

    it 'renders null' do
      expect(rendered).to include view.null
    end
  end
end
