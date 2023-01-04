# frozen_string_literal: true
require 'rails_helper'

partial_name = 'show/has_one'
describe partial_name, :wallaby_user do
  let(:partial)   { "wallaby/resources/#{partial_name}" }
  let(:value)     { Product.new id: 1, name: 'Hiking shoes' }
  let(:metadata)  { Hash class: Product }

  before do
    render partial, value: value, metadata: metadata
  end

  it 'renders the has_one' do
    expect(rendered).to include view.show_link(value)
  end

  context 'when value is nil' do
    let(:value) { nil }

    it 'renders null' do
      expect(rendered).to include view.new_link(metadata[:class])
    end
  end
end
