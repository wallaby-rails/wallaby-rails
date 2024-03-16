# frozen_string_literal: true

require 'rails_helper'

partial_name = 'show/has_and_belongs_to_many'
describe partial_name, :wallaby_user, type: :helper do
  let(:partial)   { "wallaby/resources/#{partial_name}" }
  let(:metadata)  { Hash label: 'Products', class: Product }
  let(:value) do
    [
      Product.new(id: 1, name: 'Hiking shoes'),
      Product.new(id: 2, name: 'Hiking pole'),
      Product.new(id: 3, name: 'Hiking jacket')
    ]
  end

  before do
    render partial, value: value, metadata: metadata
  end

  it 'renders the has_and_belongs_to_many' do
    expect(rendered).to include view.show_link(value[0])
    expect(rendered).to include view.show_link(value[1])
    expect(rendered).to include view.show_link(value[2])
    expect(rendered).to include view.new_link(metadata[:class])
  end

  context 'when value is []' do
    let(:value) { [] }

    it 'renders null' do
      expect(rendered).to include view.new_link(metadata[:class])
    end
  end
end
