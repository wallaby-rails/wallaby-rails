require 'rails_helper'

partial_name = 'index/has_one'
describe partial_name, :current_user do
  let(:partial)   { "wallaby/resources/#{ partial_name }.html.erb" }
  let(:value)     { Product.new id: 1, name: 'Hiking shoes' }
  let(:metadata)  { {} }

  before { render partial, value: value, metadata: metadata }

  it 'renders the has_one' do
    expect(rendered).to eq "<a href=\"/admin/products/1\">Hiking shoes</a>\n"
  end

  context 'when value is nil' do
    let(:value) { nil }
    it 'renders null' do
      expect(rendered).to eq "<i class=\"text-muted\">&lt;null&gt;</i>\n"
    end
  end
end
