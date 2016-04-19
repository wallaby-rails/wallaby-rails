require 'rails_helper'

partial_name = 'index/has_many'
describe partial_name, :current_user do
  let(:partial)   { "wallaby/resources/#{ partial_name }.html.erb" }
  let(:value) do
    [
      Product.new(id: 1, name: 'Hiking shoes'),
      Product.new(id: 2, name: 'Hiking pole'),
      Product.new(id: 3, name: 'Hiking jacket')
    ]
  end
  let(:metadata)  { Hash label: 'Products' }

  before do
    allow(view).to receive(:random_uuid) { '9877d72f-26fa-426b-8a1b-6ef012f9112b' }
    render partial, value: value, metadata: metadata
  end

  it 'renders the has_many' do
    expect(rendered).to eq "<a href=\"/admin/products/1\">Hiking shoes</a>, <a href=\"/admin/products/2\">Hiking pole</a>\n\n  and <a data-toggle=\"modal\" data-target=\"#9877d72f-26fa-426b-8a1b-6ef012f9112b\" href=\"javascript:;\">1 more</a><div id=\"9877d72f-26fa-426b-8a1b-6ef012f9112b\" class=\"modal fade\" tabindex=\"-1\" role=\"dialog\"><div class=\"modal-dialog modal-lg\"><div class=\"modal-content\"><div class=\"modal-header\"><button name=\"button\" type=\"button\" class=\"close\" data-dismiss=\"modal\" aria-label=\"Close\"><span aria-hidden=\"true\">&times;</span></button><h4 class=\"modal-title\">Products</h4></div><div class=\"modal-body\"><a href=\"/admin/products/1\">Hiking shoes</a>, <a href=\"/admin/products/2\">Hiking pole</a>, and <a href=\"/admin/products/3\">Hiking jacket</a></div></div></div></div>\n"
  end

  context 'when value size is no more than 2' do
    let(:value) do
      [
        Product.new(id: 1, name: 'Hiking shoes'),
        Product.new(id: 2, name: 'Hiking pole')
      ]
    end

    it 'renders the has_many' do
      expect(rendered).to eq "<a href=\"/admin/products/1\">Hiking shoes</a>, <a href=\"/admin/products/2\">Hiking pole</a>\n\n"
    end
  end

  context 'when value is []' do
    let(:value) { [] }

    it 'renders null' do
      expect(rendered).to eq "\n\n  <i class=\"text-muted\">&lt;null&gt;</i>\n"
    end
  end
end
