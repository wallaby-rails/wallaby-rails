require 'rails_helper'

describe Wallaby::ActiveRecord::ModelDecorator::FieldsBuilder::AssociationBuilder do
  subject { described_class.new }

  describe 'metadata' do
    let(:model_class) do
      Class.new(ActiveRecord::Base) do
        self.table_name = 'products'
        def self.name; 'Product'; end
      end
    end

    it 'checks is_through' do
      metadata = {}
      model_class.has_many :order_items, class_name: Order::Item.name
      model_class.has_many :orders, through: :order_items
      subject.update(metadata, model_class.reflections['orders'])
      expect(metadata[:is_through]).to be_truthy

      model_class.has_one :product_detail
      subject.update(metadata, model_class.reflections['product_detail'])
      expect(metadata[:is_through]).to be_falsy

      metadata = {}
      subject.update(metadata, Order::Item.reflections['product_detail'])
      expect(metadata[:is_through]).to be_truthy
    end

    it 'checks has_scope' do
      metadata = {}
      model_class.has_many :order_items, class_name: Order::Item.name
      subject.update(metadata, model_class.reflections['order_items'])
      expect(metadata[:has_scope]).to be_falsy

      model_class.has_many :many_items, -> { where('quantity > 100') }, class_name: Order::Item.name
      metadata = {}
      subject.update(metadata, model_class.reflections['many_items'])
      expect(metadata[:has_scope]).to be_truthy
    end

    describe 'foreign_key' do
      describe 'belongs_to' do
        let(:model_class) do
          Class.new(ActiveRecord::Base) do
            self.table_name = 'order_items'
            def self.name; 'Order::Item'; end
          end
        end

        it 'returns foreign_key' do
          metadata = {}
          model_class.belongs_to :order
          subject.update(metadata, model_class.reflections['order'])
          expect(metadata[:foreign_key]).to eq 'order_id'

          metadata = {}
          model_class.belongs_to :ordering, class_name: Order.name
          subject.update(metadata, model_class.reflections['ordering'])
          expect(metadata[:foreign_key]).to eq 'ordering_id'

          metadata = {}
          model_class.belongs_to :orderings, foreign_key: 'order_id', class_name: Order.name
          subject.update(metadata, model_class.reflections['orderings'])
          expect(metadata[:foreign_key]).to eq 'order_id'
        end
      end

      describe 'has_one' do
        let(:model_class) do
          Class.new(ActiveRecord::Base) do
            self.table_name = 'order_items'
            def self.name; 'Order::Item'; end
          end
        end

        it 'returns foreign_key' do
          metadata = {}
          model_class.has_one :picture, as: :imageable
          subject.update(metadata, model_class.reflections['picture'])
          expect(metadata[:foreign_key]).to eq 'picture_id'

          metadata = {}
          model_class.belongs_to :product
          model_class.has_one :product_detail, through: :product
          subject.update(metadata, model_class.reflections['product_detail'])
          expect(metadata[:foreign_key]).to eq 'product_detail_id'
        end
      end

      describe 'has_many' do
        it 'returns foreign_key' do
          metadata = {}
          model_class.has_many :order_items, class_name: Order::Item.name
          subject.update(metadata, model_class.reflections['order_items'])
          expect(metadata[:foreign_key]).to eq 'order_item_ids'

          model_class.has_many :items, class_name: Order::Item.name
          subject.update(metadata, model_class.reflections['items'])
          expect(metadata[:foreign_key]).to eq 'item_ids'

          metadata = {}
          model_class.has_many :orders, through: :order_items
          subject.update(metadata, model_class.reflections['orders'])
          expect(metadata[:foreign_key]).to eq 'order_ids'
        end
      end

      describe 'has_and_belongs_to_many' do
        it 'returns foreign_key' do
          metadata = {}
          model_class.has_and_belongs_to_many :tags
          subject.update(metadata, model_class.reflections['tags'])
          expect(metadata[:foreign_key]).to eq 'tag_ids'
        end
      end
    end
  end
end
