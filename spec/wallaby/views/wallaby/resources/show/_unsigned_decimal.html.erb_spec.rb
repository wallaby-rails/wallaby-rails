# frozen_string_literal: true

require 'rails_helper'

partial_name = 'show/unsigned_decimal'
describe partial_name, type: :view do
  let(:partial)   { "wallaby/resources/#{partial_name}" }
  let(:value)     { (BigDecimal('42')**13) / (10**20) }
  let(:metadata)  { {} }

  before do
    render partial, value: value, metadata: metadata
  end

  it 'renders the unsigned_decimal' do
    expect(rendered).to include value.to_s
  end

  context 'when value is 0' do
    let(:value) { BigDecimal('0') }

    it 'renders the unsigned_decimal' do
      expect(rendered).to include value.to_s
    end
  end

  context 'when value is nil' do
    let(:value) { nil }

    it 'renders null' do
      expect(rendered).to include view.null
    end
  end
end
