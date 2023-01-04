# frozen_string_literal: true
require 'rails_helper'

partial_name = 'show/bigint'
describe partial_name do
  let(:partial)   { "wallaby/resources/#{partial_name}" }
  let(:value)     { BigDecimal('42')**20 }
  let(:metadata)  { {} }

  before do
    render partial, value: value, metadata: metadata
  end

  it 'renders the bigint' do
    expect(rendered).to include value.to_s
  end

  context 'when value is 0' do
    let(:value) { 0 }

    it 'renders the bigint' do
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
