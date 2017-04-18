require 'rails_helper'

partial_name = 'show/has_many'
describe partial_name, :current_user do
  let(:partial)   { "wallaby/resources/#{partial_name}.html.erb" }
  let(:value) do
    [
      Product.new(id: 1, name: 'Hiking shoes'),
      Product.new(id: 2, name: 'Hiking pole'),
      Product.new(id: 3, name: 'Hiking jacket')
    ]
  end
  let(:metadata)  { Hash label: 'Products', class: Product }

  before { render partial, value: value, metadata: metadata }

  it 'renders the has_many' do
    expect(rendered).to eq "  <a href=\"/admin/products/1\">Hiking shoes</a>, <a href=\"/admin/products/2\">Hiking pole</a>, and <a href=\"/admin/products/3\">Hiking jacket</a>\nor <a class=\"text-success\" href=\"/admin/products/new\">Create Product</a>\n"
  end

  context 'when value size is no more than 2' do
    let(:value) do
      [
        Product.new(id: 1, name: 'Hiking shoes'),
        Product.new(id: 2, name: 'Hiking pole')
      ]
    end

    it 'renders the has_many' do
      expect(rendered).to eq "  <a href=\"/admin/products/1\">Hiking shoes</a> and <a href=\"/admin/products/2\">Hiking pole</a>\nor <a class=\"text-success\" href=\"/admin/products/new\">Create Product</a>\n"
    end
  end

  context 'when value is []' do
    let(:value) { [] }

    it 'renders null' do
      expect(rendered).to eq "<a class=\"text-success\" href=\"/admin/products/new\">Create Product</a>\n"
    end
  end
end
