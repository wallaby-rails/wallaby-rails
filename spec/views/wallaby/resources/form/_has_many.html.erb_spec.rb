require 'rails_helper'

field_name = 'order_items'
describe field_name, :current_user do
  it_behaves_like 'form partial', field_name,
    model_class: Product,
    partial_name: 'has_many',
    content_for: true,
    skip_general: true,
    skip_errors: true,
    skip_nil: true do

    let(:object) { Product.create! metadata[:name] => value }
    let!(:targets) { [Order::Item.create!(id: 1)] }
    let(:value) { targets }
    let(:metadata) do
      {
        name: 'order_items', type: 'has_many', label: 'Order / Items',
        is_association: true, is_polymorphic: false, is_through: false, has_scope: false, foreign_key: 'order_item_ids', polymorphic_type: nil, polymorphic_list: [], class: Order::Item
      }
    end

    it 'renders the has_many form' do
      init = page.at_css('[data-init]')
      expect(init['data-wildcard']).to eq 'QUERY'
      expect(init['data-url']).to eq '/admin/order::items?per=20&q=QUERY'

      selected = page.at_css('[data-init] ul li input')
      expect(selected['id']).to be_blank
      expect(selected['name']).to eq "product[#{metadata[:foreign_key]}][]"
      expect(selected['multiple']).to eq 'multiple'
      expect(selected['value']).to eq targets.first.id.to_s
    end

    context 'when has errors' do
      let!(:object) do
        Product.create!(metadata[:name] => value).tap do |record|
          record.errors.add field_name, error_message
        end
      end
      let(:error_message) { 'something wrong' }

      it 'renders the errors' do
        selected = page.css('[data-init] ul li input')
        expect(selected.length).to eq 1

        first = selected.first
        expect(first['id']).to be_blank
        expect(first['name']).to eq "product[#{metadata[:foreign_key]}][]"
        expect(first['multiple']).to be_present

        form_group = page.at_css('.form-group')
        expect(form_group['class']).to include 'error'
        error = page.at_css('ul.errors li')
        expect(error.content).to eq error_message
      end
    end

    context 'when value is empty array' do
      let(:object) { Product.new }
      let(:value) { [] }

      it 'renders the has_many form' do
        selected = page.at_css('[data-init] ul li input')
        expect(selected).to be_blank
      end
    end

    context 'when value is nil' do
      let(:object) { Product.new }
      let(:value) { nil }

      it 'renders the has_many form' do
        selected = page.at_css('[data-init] ul li input')
        expect(selected).to be_blank
      end
    end
  end
end
