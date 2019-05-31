require 'rails_helper'

field_name = 'product_detail'
describe field_name, :current_user do
  it_behaves_like \
    'form partial', field_name,
    model_class: Product,
    partial_name: 'has_one',
    skip_general: true,
    skip_errors: true,
    skip_nil: true do
    let(:object) { Product.create! metadata[:name] => value }
    let!(:target) { ProductDetail.new id: 1 }
    let(:value) { target }
    let(:metadata) do
      {
        name: 'product_detail', type: 'has_one', label: 'Product Detail',
        is_association: true, is_polymorphic: false, is_through: false, has_scope: false,
        foreign_key: 'product_detail_id', polymorphic_type: nil, polymorphic_list: [], class: ProductDetail
      }
    end

    it 'renders the has_one form' do
      link = page.at_css('.form-group a')
      expect(link['href']).to eq view.edit_path(value)
    end

    context 'when nil' do
      let(:object) { Product.new }
      let(:value) { nil }

      it 'renders the has_one form' do
        link = page.at_css('.form-group a')
        expect(link['href']).to eq view.new_path(metadata[:class])
      end
    end
  end
end
