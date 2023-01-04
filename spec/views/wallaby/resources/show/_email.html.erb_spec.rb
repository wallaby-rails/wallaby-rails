# frozen_string_literal: true
require 'rails_helper'

partial_name = 'show/email'
describe partial_name do
  let(:partial)   { "wallaby/resources/#{partial_name}" }
  let(:value)     { 'tian@reinteractive.net' }
  let(:metadata)  { {} }

  before do
    render partial, value: value, metadata: metadata
  end

  it 'renders the email' do
    expect(rendered).to include "mailto:#{value}"
  end

  context 'when value is nil' do
    let(:value) { nil }

    it 'renders null' do
      expect(rendered).to include view.null
    end
  end
end
