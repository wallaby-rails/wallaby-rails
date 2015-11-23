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
      expect(subject.general_fields).to eq({
        "id" => {
          name: "id", type: :integer, label: "Id"
        },
        "category_id" => {
          name: "category_id", type: :integer, label: "Category"
        },
        "sku" => {
          name: "sku", type: :string, label: "Sku"
        },
        "name" => {
          name: "name", type: :string, label: "Name"
        },
        "description" => {
          name: "description", type: :text, label: "Description"
        },
        "stock" => {
          name: "stock", type: :integer, label: "Stock"
        },
        "price" => {
          name: "price", type: :float, label: "Price"
        },
        "featured" => {
          name: "featured", type: :boolean, label: "Featured"
        },
        "available_to_date" => {
          name: "available_to_date", type: :date, label: "Available to date"
        },
        "available_to_time" => {
          name: "available_to_time", type: :time, label: "Available to time"
        },
        "published_at" => {
          name: "published_at", type: :datetime, label: "Published at"
        }
      })
    end
  end

  describe '#association_fields' do
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
        expect(subject.association_fields['category']).to eq({
          name: "category",
          type: "belongs_to",
          label: "Category",
          is_polymorphic: false,
          is_through: false,
          has_scope: false,
          foreign_key: "category_id",
          foreign_type: nil,
          foreign_list: [],
          class: Category
        })
      end
    end

    context 'for has_one' do
      it 'returns association_fields that has a has_one association' do
        model_class.has_one :product_detail
        model_class.has_one :picture, as: :imageable
        expect(subject.association_fields['product_detail']).to eq({
          name: "product_detail",
          type: "has_one",
          label: "Product Detail",
          is_polymorphic: false,
          is_through: false,
          has_scope: false,
          foreign_key: "product_detail_id",
          foreign_type: nil,
          foreign_list: [],
          class: ProductDetail
        })

        expect(subject.association_fields['picture']).to eq({
          name: "picture",
          type: "has_one",
          label: "Picture",
          is_polymorphic: true,
          is_through: false,
          has_scope: false,
          foreign_key: "picture_id",
          foreign_type: "picture_type",
          foreign_list: [],
          class: nil
        })
      end
    end

    context 'for has_many' do
      it 'returns association_fields that has a has_many association' do
        model_class.has_many :items, class_name: 'Order::Item'
        model_class.has_many :orders, through: :items
        model_class.has_many :pictures, as: :imageable
        expect(subject.association_fields['items']).to eq({
          name: "items",
          type: "has_many",
          label: "Order / Items",
          is_polymorphic: false,
          is_through: false,
          has_scope: false,
          foreign_key: "order_item_ids",
          foreign_type: nil,
          foreign_list: [],
          class: Order::Item
        })

        expect(subject.association_fields['orders']).to eq({
          name: "orders",
          type: "has_many",
          label: "Orders",
          is_polymorphic: false,
          is_through: true,
          has_scope: false,
          foreign_key: "order_ids",
          foreign_type: nil,
          foreign_list: [],
          class: Order
        })

        expect(subject.association_fields['pictures']).to eq({
          name: "pictures",
          type: "has_many",
          label: "Pictures",
          is_polymorphic: true,
          is_through: false,
          has_scope: false,
          foreign_key: "picture_ids",
          foreign_type: "picture_type",
          foreign_list: [],
          class: nil
        })
      end
    end
  end
end