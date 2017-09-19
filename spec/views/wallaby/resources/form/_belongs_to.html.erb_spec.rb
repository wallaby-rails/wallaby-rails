require 'rails_helper'

field_name = 'category_id'
describe field_name, :current_user do
  it_behaves_like 'form partial', field_name,
    model_class: Product,
    partial_name: 'belongs_to',
    content_for: true,
    skip_general: true,
    skip_errors: true,
    skip_nil: true do

    let(:object) { Product.create! metadata[:name] => value }
    let!(:target) { Category.create! id: 1, name: 'Mens' }
    let(:value) { target }
    let(:metadata) do
      {
        name: 'category', type: 'belongs_to', label: 'Category',
        is_association: true, is_polymorphic: false, is_through: false, has_scope: false,
        foreign_key: 'category_id', polymorphic_type: nil, polymorphic_list: [], class: Category
      }
    end

    it 'renders the belongs_to form' do
      init = page.at_css('[data-init]')
      expect(init['data-wildcard']).to eq 'QUERY'
      expect(init['data-url']).to eq '/admin/categories?per=20&q=QUERY'

      selected = page.css('[data-init] ul li input')
      expect(selected.length).to eq 1

      first = selected.first
      expect(first['id']).to be_blank
      expect(first['name']).to eq "product[#{metadata[:foreign_key]}]"
      expect(first['multiple']).to be_blank
      expect(first['value']).to eq target.id.to_s
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
        expect(first['name']).to eq "product[#{metadata[:foreign_key]}]"
        expect(first['multiple']).to be_blank
        expect(first['value']).to eq target.id.to_s

        form_group = page.at_css('.form-group')
        expect(form_group['class']).to include 'error'
        error = page.at_css('ul.errors li')
        expect(error.content).to eq error_message
      end
    end

    context 'when nil' do
      let(:object) { Product.new }
      let(:value) { nil }

      it 'renders the belongs_to form' do
        selected = page.at_css('[data-init] ul li input')
        expect(selected).to be_blank
      end
    end
  end

  context 'when polymorphic' do
    it_behaves_like 'form partial', field_name,
      model_class: Picture,
      partial_name: 'belongs_to',
      skip_general: true,
      skip_errors: true,
      skip_nil: true do

      let(:object) { Picture.new metadata[:name] => value }
      let!(:target) { Product.new id: 1, name: 'Snowboard' }
      let(:value) { target }
      let(:metadata) do
        {
          name: 'imageable', type: 'belongs_to', label: 'Imageable', is_association: true,
          is_polymorphic: true, is_through: false, has_scope: false,
          foreign_key: 'imageable_id', polymorphic_type: 'imageable_type', polymorphic_list: [Product], class: nil
        }
      end

      it 'renders the belongs_to form' do
        selected_klass = page.at_css('[data-init] select option[selected]')
        expect(selected_klass['value']).to eq target.class.name
        selected = page.css('[data-init] ul li input')
        expect(selected.length).to eq 1
        expect(selected.first['value']).to eq target.id.to_s
      end

      context 'when has errors' do
        let!(:object) do
          Picture.new(metadata[:name] => value).tap do |record|
            record.errors.add field_name, error_message
          end
        end
        let(:error_message) { 'something wrong' }

        it 'renders the errors' do
          selected_klass = page.at_css('[data-init] select option[selected]')
          expect(selected_klass['value']).to eq target.class.name
          selected = page.css('[data-init] ul li input')
          expect(selected.length).to eq 1
          expect(selected.first['value']).to eq target.id.to_s

          form_group = page.at_css('.form-group')
          expect(form_group['class']).to include 'error'
          error = page.at_css('ul.errors li')
          expect(error.content).to eq error_message
        end
      end

      context 'when nil' do
        let(:object) { Picture.new }
        let(:value) { nil }

        it 'renders the polymorphic form' do
          selected_klass = page.at_css('[data-init] select option[selected]')
          expect(selected_klass).to be_blank
          selected = page.at_css('[data-init] ul li input')
          expect(selected).to be_blank
        end
      end
    end
  end
end
