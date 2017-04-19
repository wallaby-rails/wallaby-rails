require 'rails_helper'

partial_name = 'show/belongs_to'
describe partial_name, :current_user do
  let(:partial)   { "wallaby/resources/#{partial_name}.html.erb" }
  let(:value)     { Product.new id: 1, name: 'Hiking shoes' }
  let(:metadata)  { Hash class: Product }

  before { render partial, value: value, metadata: metadata }

  it 'renders the belongs_to' do
    expect(rendered).to eq "  <a href=\"/admin/products/1\">Hiking shoes</a>\n"
  end

  context 'when value is nil' do
    let(:value) { nil }
    it 'renders new_link' do
      expect(rendered).to eq "  <a class=\"text-success\" href=\"/admin/products/new\">Create Product</a>\n"
    end

    context 'when value is polymorphic' do
      let(:metadata) { Hash is_polymorphic: true }
      it 'renders new_link' do
        expect(rendered).to eq "  <i class=\"text-muted\">&lt;null&gt;</i>\n"
      end
    end
  end
end
