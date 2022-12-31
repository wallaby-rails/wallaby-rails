# frozen_string_literal: true
require 'rails_helper'

partial_name = 'show/numrange'
describe partial_name do
  let(:partial)   { "wallaby/resources/#{partial_name}.html.erb" }
  let(:value)     { 1..100 }
  let(:metadata)  { {} }

  before do
    render partial, value: value, metadata: metadata
  end

  it 'renders the numrange' do
    expect(rendered).to eq "  <span class=\"from\">1</span>\n  ...\n  <span class=\"to\">100</span>\n"
  end

  context 'when value is nil' do
    let(:value) { nil }

    it 'renders null' do
      expect(rendered).to include view.null
    end
  end
end
