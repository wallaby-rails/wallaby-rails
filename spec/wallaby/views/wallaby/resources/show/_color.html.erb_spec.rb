# frozen_string_literal: true

require 'rails_helper'

partial_name = 'show/color'
describe partial_name, type: :view do
  let(:partial)   { "wallaby/resources/#{partial_name}" }
  let(:value)     { '#000000' }
  let(:metadata)  { {} }

  before do
    render partial, value: value, metadata: metadata
  end

  it 'renders the string' do
    expect(rendered).to include "background-color: #{value};"
    expect(rendered).to include "<span class=\"text-uppercase\">#{value}</span>"
  end

  context 'when value is nil' do
    let(:value) { nil }

    it 'renders null' do
      expect(rendered).to include view.null
    end
  end
end
