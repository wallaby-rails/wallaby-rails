require 'rails_helper'

partial_name = 'show/has_many'
describe partial_name, :current_user do
  let(:partial)   { "wallaby/resources/#{partial_name}.html.erb" }
  let(:metadata)  { Hash label: 'Products', class: Product }
  let(:value) do
    [
      Product.new(id: 1, name: 'Hiking shoes'),
      Product.new(id: 2, name: 'Hiking pole'),
      Product.new(id: 3, name: 'Hiking jacket')
    ]
  end

  before { render partial, value: value, metadata: metadata }

  it 'renders the has_many' do
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
