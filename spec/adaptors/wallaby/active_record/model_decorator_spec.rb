require 'rails_helper'

describe Wallaby::ActiveRecord::ModelDecorator do
  subject { described_class.new model_class }
  let(:model_class) { AllPostgresType }

  describe 'General fields' do
    describe '#fields' do
      it 'returns a hash of all keys' do
        expect(subject.fields).to be_a HashWithIndifferentAccess
        expect(subject.fields).to eq(
          'id' => {
            'name' => 'id', 'type' => 'integer', 'label' => 'Id', 'is_origin' => true
          },
          'string' => {
            'name' => 'string', 'type' => 'string', 'label' => 'String', 'is_origin' => true
          },
          'text' => {
            'name' => 'text', 'type' => 'text', 'label' => 'Text', 'is_origin' => true
          },
          'integer' => {
            'name' => 'integer', 'type' => 'integer', 'label' => 'Integer', 'is_origin' => true
          },
          'float' => {
            'name' => 'float', 'type' => 'float', 'label' => 'Float', 'is_origin' => true
          },
          'decimal' => {
            'name' => 'decimal', 'type' => 'decimal', 'label' => 'Decimal', 'is_origin' => true
          },
          'datetime' => {
            'name' => 'datetime', 'type' => 'datetime', 'label' => 'Datetime', 'is_origin' => true
          },
          'time' => {
            'name' => 'time', 'type' => 'time', 'label' => 'Time', 'is_origin' => true
          },
          'date' => {
            'name' => 'date', 'type' => 'date', 'label' => 'Date', 'is_origin' => true
          },
          'daterange' => {
            'name' => 'daterange', 'type' => 'daterange', 'label' => 'Daterange', 'is_origin' => true
          },
          'numrange' => {
            'name' => 'numrange', 'type' => 'numrange', 'label' => 'Numrange', 'is_origin' => true
          },
          'tsrange' => {
            'name' => 'tsrange', 'type' => 'tsrange', 'label' => 'Tsrange', 'is_origin' => true
          },
          'tstzrange' => {
            'name' => 'tstzrange', 'type' => 'tstzrange', 'label' => 'Tstzrange', 'is_origin' => true
          },
          'int4range' => {
            'name' => 'int4range', 'type' => 'int4range', 'label' => 'Int4range', 'is_origin' => true
          },
          'int8range' => {
            'name' => 'int8range', 'type' => 'int8range', 'label' => 'Int8range', 'is_origin' => true
          },
          'binary' => {
            'name' => 'binary', 'type' => 'binary', 'label' => 'Binary', 'is_origin' => true
          },
          'boolean' => {
            'name' => 'boolean', 'type' => 'boolean', 'label' => 'Boolean', 'is_origin' => true
          },
          'bigint' => {
            'name' => 'bigint', 'type' => 'integer', 'label' => 'Bigint', 'is_origin' => true
          },
          'xml' => {
            'name' => 'xml', 'type' => 'xml', 'label' => 'Xml', 'is_origin' => true
          },
          'tsvector' => {
            'name' => 'tsvector', 'type' => 'tsvector', 'label' => 'Tsvector', 'is_origin' => true
          },
          'hstore' => {
            'name' => 'hstore', 'type' => 'hstore', 'label' => 'Hstore', 'is_origin' => true
          },
          'inet' => {
            'name' => 'inet', 'type' => 'inet', 'label' => 'Inet', 'is_origin' => true
          },
          'cidr' => {
            'name' => 'cidr', 'type' => 'cidr', 'label' => 'Cidr', 'is_origin' => true
          },
          'macaddr' => {
            'name' => 'macaddr', 'type' => 'macaddr', 'label' => 'Macaddr', 'is_origin' => true
          },
          'uuid' => {
            'name' => 'uuid', 'type' => 'uuid', 'label' => 'Uuid', 'is_origin' => true
          },
          'json' => {
            'name' => 'json', 'type' => 'json', 'label' => 'Json', 'is_origin' => true
          },
          'jsonb' => {
            'name' => 'jsonb', 'type' => 'jsonb', 'label' => 'Jsonb', 'is_origin' => true
          },
          'ltree' => {
            'name' => 'ltree', 'type' => 'ltree', 'label' => 'Ltree', 'is_origin' => true
          },
          'citext' => {
            'name' => 'citext', 'type' => 'citext', 'label' => 'Citext', 'is_origin' => true
          },
          'point' => {
            'name' => 'point', 'type' => 'point', 'label' => 'Point', 'is_origin' => true
          },
          'bit' => {
            'name' => 'bit', 'type' => 'bit', 'label' => 'Bit', 'is_origin' => true
          },
          'bit_varying' => {
            'name' => 'bit_varying', 'type' => 'bit_varying', 'label' => 'Bit varying', 'is_origin' => true
          },
          'money' => {
            'name' => 'money', 'type' => 'money', 'label' => 'Money', 'is_origin' => true
          }
        )
      end

      context 'when model table does not exist' do
        let(:model_class) { UnknowLand = Class.new ActiveRecord::Base }

        it 'renders blank hash and throw no error' do
          expect { subject.fields }.not_to raise_error
          expect(subject.fields).to be_blank
        end
      end
    end

    describe '#index_fields' do
      it 'has same value as fields' do
        expect(subject.index_fields).to be_a HashWithIndifferentAccess
        expect(subject.index_fields).to eq subject.fields
      end

      context 'changing index_fields' do
        it 'doesnt modify fields' do
          expect { subject.index_fields['id'][:label] = 'ID' }.not_to(change { subject.fields['id'][:label] })
        end
      end
    end

    describe '#show_fields' do
      it 'has same value as fields' do
        expect(subject.show_fields).to be_a HashWithIndifferentAccess
        expect(subject.show_fields).to eq subject.fields
      end

      context 'changing show_fields' do
        it 'doesnt modify fields' do
          expect { subject.show_fields['id'][:label] = 'ID' }.not_to(change { subject.fields['id'][:label] })
        end
      end
    end

    describe '#form_fields' do
      it 'has same value as fields' do
        expect(subject.form_fields).to be_a HashWithIndifferentAccess
        expect(subject.form_fields).to eq subject.fields
      end

      context 'changing form_fields' do
        it 'doesnt modify fields' do
          expect { subject.form_fields['id'][:label] = 'ID' }.not_to(change { subject.fields['id'][:label] })
        end
      end
    end

    describe '#index_field_names' do
      it 'excludes fields that have long value' do
        expect(subject.index_field_names).to eq %w[id string integer float decimal datetime time date daterange numrange tsrange tstzrange int4range int8range boolean bigint inet cidr macaddr uuid ltree point bit bit_varying money]
      end
    end

    describe '#form_field_names' do
      it 'excludes id, created_at, updated_at, has_scope and is_through fields' do
        expect(subject.form_field_names).to eq %w[string text integer float decimal datetime time date daterange numrange tsrange tstzrange int4range int8range binary boolean bigint xml tsvector hstore inet cidr macaddr uuid json jsonb ltree citext point bit bit_varying money]
      end
    end
  end

  describe 'Association fields' do
    let(:model_class) { Product }
    describe '#fields' do
      it 'returns a hash of all keys' do
        expect(subject.fields).to eq(
          'id' => {
            'name' => 'id', 'type' => 'integer', 'label' => 'Id', 'is_origin' => true
          },
          'sku' => {
            'name' => 'sku', 'type' => 'string', 'label' => 'Sku', 'is_origin' => true
          },
          'name' => {
            'name' => 'name', 'type' => 'string', 'label' => 'Name', 'is_origin' => true
          },
          'description' => {
            'name' => 'description', 'type' => 'text', 'label' => 'Description', 'is_origin' => true
          },
          'stock' => {
            'name' => 'stock', 'type' => 'integer', 'label' => 'Stock', 'is_origin' => true
          },
          'price' => {
            'name' => 'price', 'type' => 'float', 'label' => 'Price', 'is_origin' => true
          },
          'featured' => {
            'name' => 'featured', 'type' => 'boolean', 'label' => 'Featured', 'is_origin' => true
          },
          'available_to_date' => {
            'name' => 'available_to_date', 'type' => 'date', 'label' => 'Available to date', 'is_origin' => true
          },
          'available_to_time' => {
            'name' => 'available_to_time', 'type' => 'time', 'label' => 'Available to time', 'is_origin' => true
          },
          'published_at' => {
            'name' => 'published_at', 'type' => 'datetime', 'label' => 'Published at', 'is_origin' => true
          },
          'product_detail' => {
            'name' => 'product_detail', 'type' => 'has_one', 'label' => 'Product detail', 'is_origin' => true, 'is_association' => true, 'is_through' => false, 'has_scope' => false, 'foreign_key' => 'product_detail_id', 'class' => ProductDetail
          },
          'picture' => {
            'name' => 'picture', 'type' => 'has_one', 'label' => 'Picture', 'is_origin' => true, 'is_association' => true, 'is_through' => false, 'has_scope' => true, 'foreign_key' => 'picture_id', 'class' => Picture
          },
          'order_items' => {
            'name' => 'order_items', 'type' => 'has_many', 'label' => 'Order items', 'is_origin' => true, 'is_association' => true, 'is_through' => false, 'has_scope' => false, 'foreign_key' => 'order_item_ids', 'class' => Order::Item
          },
          'orders' => {
            'name' => 'orders', 'type' => 'has_many', 'label' => 'Orders', 'is_origin' => true, 'is_association' => true, 'is_through' => true, 'has_scope' => false, 'foreign_key' => 'order_ids', 'class' => Order
          },
          'category' => {
            'name' => 'category', 'type' => 'belongs_to', 'label' => 'Category', 'is_origin' => true, 'is_association' => true, 'is_through' => false, 'has_scope' => false, 'foreign_key' => 'category_id', 'class' => Category
          },
          'tags' => {
            'name' => 'tags', 'type' => 'has_and_belongs_to_many', 'label' => 'Tags', 'is_origin' => true, 'is_association' => true, 'is_through' => false, 'has_scope' => false, 'foreign_key' => 'tag_ids', 'class' => Tag
          }
        )
      end
    end

    describe '#index_field_names' do
      it 'excludes fields that have long value' do
        expect(subject.index_field_names).to eq %w[id sku name stock price featured available_to_date available_to_time published_at]
      end
    end

    describe '#form_field_names' do
      it 'excludes id, created_at, updated_at, has_scope and is_through fields' do
        expect(subject.form_field_names).to eq %w[sku name description stock price featured available_to_date available_to_time published_at product_detail order_items category tags]
      end
    end

    describe '#foreign_keys_from_associations' do
      it 'returns foreign keys for associations' do
        expect(subject.send(:foreign_keys_from_associations)).to eq %w[product_detail_id picture_id order_item_ids order_ids category_id tag_ids]
      end
    end

    describe '#many_associations' do
      it 'returns associations' do
        expect(subject.send(:many_associations).keys).to eq %w[order_items tags]
      end
    end

    describe '#belongs_to_associations' do
      it 'returns associations' do
        expect(subject.send(:belongs_to_associations).keys).to eq %w[category]
      end
    end
  end

  describe 'Polymorphic fields' do
    let(:model_class) { Picture }
    describe '#fields' do
      it 'returns a hash of all keys' do
        expect(subject.fields).to eq(
          'id' => {
            'name' => 'id', 'type' => 'integer', 'label' => 'Id', 'is_origin' => true
          },
          'name' => {
            'name' => 'name', 'type' => 'string', 'label' => 'Name', 'is_origin' => true
          },
          'file' => {
            'name' => 'file', 'type' => 'binary', 'label' => 'File', 'is_origin' => true
          },
          'created_at' => {
            'name' => 'created_at', 'type' => 'datetime', 'label' => 'Created at', 'is_origin' => true
          },
          'updated_at' => {
            'name' => 'updated_at', 'type' => 'datetime', 'label' => 'Updated at', 'is_origin' => true
          },
          'imageable' => {
            'name' => 'imageable', 'type' => 'belongs_to', 'label' => 'Imageable', 'is_origin' => true, 'is_association' => true, 'is_polymorphic' => true, 'is_through' => false, 'has_scope' => false, 'foreign_key' => 'imageable_id', 'polymorphic_type' => 'imageable_type', 'polymorphic_list' => [Product]
          }
        )
      end
    end

    describe '#index_field_names' do
      it 'excludes fields that have long value' do
        expect(subject.index_field_names).to eq %w[id name created_at updated_at]
      end
    end

    describe '#form_field_names' do
      it 'excludes id, created_at, updated_at, has_scope and is_through fields' do
        expect(subject.form_field_names).to eq %w[name file imageable]
      end
    end

    describe '#foreign_keys_from_associations' do
      it 'returns ploymorphic foreign keys for associations' do
        expect(subject.send(:foreign_keys_from_associations)).to eq %w[imageable_id imageable_type]
      end
    end

    describe '#many_associations' do
      it 'returns associations' do
        expect(subject.send(:many_associations).keys).to eq []
      end
    end

    describe '#belongs_to_associations' do
      it 'returns associations' do
        expect(subject.send(:belongs_to_associations).keys).to eq %w[imageable]
      end
    end
  end

  describe '#form_active_errors' do
    it 'returns the form errors' do
      resource = double errors: ActiveModel::Errors.new({})
      resource.errors.add :name, 'can not be nil'
      resource.errors.add :base, 'has error'
      expect(subject.form_active_errors(resource)).to be_a ActiveModel::Errors
      expect(subject.form_active_errors(resource).messages).to eq(
        name: ['can not be nil'],
        base: ['has error']
      )
    end
  end

  describe '#primary_key' do
    it 'returns model primary_key' do
      allow(model_class).to receive(:primary_key).and_return('all_postgres_type_id')
      expect(subject.primary_key).to eq 'all_postgres_type_id'
    end
  end

  describe '#guess_title' do
    it 'returns a label for the model' do
      resource = model_class.new string: "Fisherman's Friend"
      expect(subject.guess_title(resource)).to eq "Fisherman's Friend"
    end
  end
end
