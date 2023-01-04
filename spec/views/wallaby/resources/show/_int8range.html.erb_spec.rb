# frozen_string_literal: true
require 'rails_helper'

partial_name = 'show/int8range'
describe partial_name do
  let(:partial)   { "wallaby/resources/#{partial_name}" }
  let(:value)     { BigDecimal('10')**13..BigDecimal('9') * 10**14 }
  let(:metadata)  { {} }

  before do
    render partial, value: value, metadata: metadata
  end

  it 'renders the int8range' do
    expect(rendered).to eq "  <span class=\"from\">10000000000000.0</span>\n  ...\n  <span class=\"to\">900000000000000.0</span>\n"
  end

  context 'when value is nil' do
    let(:value) { nil }

    it 'renders null' do
      expect(rendered).to include view.null
    end
  end
end
