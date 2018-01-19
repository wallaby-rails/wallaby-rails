require 'rails_helper'

describe Wallaby::ActiveRecord::ModelDecorator::FieldsBuilder do
  subject { described_class.new model_class }

  describe '#general_fields' do
    let(:model_class) do
      Class.new ActiveRecord::Base do
        def self.name
          'Product'
        end
      end
    end

    it 'returns a hash using column names as keys' do
      expect(subject.general_fields).to eq(
        'id' => {
          name: 'id', type: 'integer', label: 'Id'
        },
        'category_id' => {
          name: 'category_id', type: 'integer', label: 'Category'
        },
        'sku' => {
          name: 'sku', type: 'string', label: 'Sku'
        },
        'name' => {
          name: 'name', type: 'string', label: 'Name'
        },
        'description' => {
          name: 'description', type: 'text', label: 'Description'
        },
        'stock' => {
          name: 'stock', type: 'integer', label: 'Stock'
        },
        'price' => {
          name: 'price', type: 'float', label: 'Price'
        },
        'featured' => {
          name: 'featured', type: 'boolean', label: 'Featured'
        },
        'available_to_date' => {
          name: 'available_to_date', type: 'date', label: 'Available to date'
        },
        'available_to_time' => {
          name: 'available_to_time', type: 'time', label: 'Available to time'
        },
        'published_at' => {
          name: 'published_at', type: 'datetime', label: 'Published at'
        }
      )
    end
  end

  describe '#association_fields' do
    context 'not polymorphic' do
      let(:model_class) do
        Class.new ActiveRecord::Base do
          def self.name
            'Product'
          end
        end
      end

      it 'returns nothing if none is declared' do
        expect(subject.association_fields).to be_blank
      end

      context 'for belongs_to' do
        it 'returns association_fields that has a belongs_to association' do
          model_class.belongs_to :category
          expect(subject.association_fields['category']).to eq(
            name: 'category',
            type: 'belongs_to',
            label: 'Category',
            is_association: true,
            is_through: false,
            has_scope: false,
            foreign_key: 'category_id',
            class: Category
          )
        end
      end

      context 'for has_one' do
        it 'returns association_fields' do
          model_class.has_one :product_detail
          expect(subject.association_fields['product_detail']).to eq(
            name: 'product_detail',
            type: 'has_one',
            label: 'Product detail',
            is_association: true,
            is_through: false,
            has_scope: false,
            foreign_key: 'product_detail_id',
            class: ProductDetail
          )
        end

        context 'and as' do
          it 'returns association_fields' do
            model_class.has_one :picture, as: :imageable
            expect(subject.association_fields['picture']).to eq(
              name: 'picture',
              type: 'has_one',
              label: 'Picture',
              is_association: true,
              is_through: false,
              has_scope: false,
              foreign_key: 'picture_id',
              class: Picture
            )
          end
        end
      end

      context 'for has_many' do
        it 'returns association_fields' do
          model_class.has_many :items, class_name: 'Order::Item'
          expect(subject.association_fields['items']).to eq(
            name: 'items',
            type: 'has_many',
            label: 'Items',
            is_association: true,
            is_through: false,
            has_scope: false,
            foreign_key: 'item_ids',
            class: Order::Item
          )

          model_class.has_many :order_items, class_name: 'Order::Item'
          expect(subject.association_fields['order_items']).to eq(
            name: 'order_items',
            type: 'has_many',
            label: 'Order items',
            is_association: true,
            is_through: false,
            has_scope: false,
            foreign_key: 'order_item_ids',
            class: Order::Item
          )
        end

        context 'and through' do
          it 'returns association_fields' do
            model_class.has_many :items, class_name: 'Order::Item'
            model_class.has_many :orders, through: :items
            expect(subject.association_fields['orders']).to eq(
              name: 'orders',
              type: 'has_many',
              label: 'Orders',
              is_association: true,
              is_through: true,
              has_scope: false,
              foreign_key: 'order_ids',
              class: Order
            )
          end
        end

        context 'and as' do
          it 'returns association_fields' do
            model_class.has_many :pictures, as: :imageable
            expect(subject.association_fields['pictures']).to eq(
              name: 'pictures',
              type: 'has_many',
              label: 'Pictures',
              is_association: true,
              is_through: false,
              has_scope: false,
              foreign_key: 'picture_ids',
              class: Picture
            )
          end
        end
      end

      context 'for has_and_belongs_to_many' do
        it 'returns association_fields' do
          model_class.has_and_belongs_to_many :tags
          expect(subject.association_fields['tags']).to eq(
            name: 'tags',
            type: 'has_and_belongs_to_many',
            label: 'Tags',
            is_association: true,
            is_through: false,
            has_scope: false,
            foreign_key: 'tag_ids',
            class: Tag
          )
        end
      end
    end

    context 'when polymorphic' do
      let(:model_class) do
        Class.new ActiveRecord::Base do
          def self.name
            'Picture'
          end
        end
      end

      context 'belongs_to' do
        it 'returns association_fields' do
          model_class.belongs_to :imageable, polymorphic: true
          imageable = subject.association_fields['imageable']
          expect(imageable[:name]).to eq 'imageable'
          expect(imageable[:type]).to eq 'belongs_to'
          expect(imageable[:label]).to eq 'Imageable'
          expect(imageable[:is_association]).to be_truthy
          expect(imageable[:is_polymorphic]).to be_truthy
          expect(imageable[:is_through]).to be_falsy
          expect(imageable[:has_scope]).to be_falsy
          expect(imageable[:foreign_key]).to eq 'imageable_id'
          expect(imageable[:polymorphic_type]).to eq 'imageable_type'
          expect(imageable[:polymorphic_list]).to include Product
          expect(imageable).not_to have_key :class
        end
      end
    end
  end
end
