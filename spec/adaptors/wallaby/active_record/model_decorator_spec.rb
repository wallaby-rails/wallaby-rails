require 'rails_helper'

describe Wallaby::ActiveRecord::ModelDecorator do
  subject { described_class.new model_class }
  let(:model_class) { AllPostgresType }

  describe 'General fields' do
    describe '#fields' do
      it 'returns a hash of all keys' do
        expect(subject.fields).to be_a ::ActiveSupport::HashWithIndifferentAccess
        expect(subject.fields).to eq(
          'id' => { 'name' => 'id', 'type' => 'integer', 'label' => 'Id' },
          'bigint' => { 'name' => 'bigint', 'type' => 'integer', 'label' => 'Bigint' },
          'bigserial' => { 'name' => 'bigserial', 'type' => 'integer', 'label' => 'Bigserial' },
          'binary' => { 'name' => 'binary', 'type' => 'binary', 'label' => 'Binary' },
          'bit' => { 'name' => 'bit', 'type' => 'bit', 'label' => 'Bit' },
          'bit_varying' => { 'name' => 'bit_varying', 'type' => 'bit_varying', 'label' => 'Bit varying' },
          'boolean' => { 'name' => 'boolean', 'type' => 'boolean', 'label' => 'Boolean' },
          'box' => { 'name' => 'box', 'type' => 'box', 'label' => 'Box' },
          'cidr' => { 'name' => 'cidr', 'type' => 'cidr', 'label' => 'Cidr' },
          'circle' => { 'name' => 'circle', 'type' => 'circle', 'label' => 'Circle' },
          'citext' => { 'name' => 'citext', 'type' => 'citext', 'label' => 'Citext' },
          'color' => { 'name' => 'color', 'type' => 'string', 'label' => 'Color' },
          'date' => { 'name' => 'date', 'type' => 'date', 'label' => 'Date' },
          'daterange' => { 'name' => 'daterange', 'type' => 'daterange', 'label' => 'Daterange' },
          'datetime' => { 'name' => 'datetime', 'type' => 'datetime', 'label' => 'Datetime' },
          'decimal' => { 'name' => 'decimal', 'type' => 'decimal', 'label' => 'Decimal' },
          'email' => { 'name' => 'email', 'type' => 'string', 'label' => 'Email' },
          'float' => { 'name' => 'float', 'type' => 'float', 'label' => 'Float' },
          'hstore' => { 'name' => 'hstore', 'type' => 'hstore', 'label' => 'Hstore' },
          'inet' => { 'name' => 'inet', 'type' => 'inet', 'label' => 'Inet' },
          'int4range' => { 'name' => 'int4range', 'type' => 'int4range', 'label' => 'Int4range' },
          'int8range' => { 'name' => 'int8range', 'type' => 'int8range', 'label' => 'Int8range' },
          'integer' => { 'name' => 'integer', 'type' => 'integer', 'label' => 'Integer' },
          'json' => { 'name' => 'json', 'type' => 'json', 'label' => 'Json' },
          'jsonb' => { 'name' => 'jsonb', 'type' => 'jsonb', 'label' => 'Jsonb' },
          'line' => { 'name' => 'line', 'type' => 'line', 'label' => 'Line' },
          'lseg' => { 'name' => 'lseg', 'type' => 'lseg', 'label' => 'Lseg' },
          'ltree' => { 'name' => 'ltree', 'type' => 'ltree', 'label' => 'Ltree' },
          'macaddr' => { 'name' => 'macaddr', 'type' => 'macaddr', 'label' => 'Macaddr' },
          'money' => { 'name' => 'money', 'type' => 'money', 'label' => 'Money' },
          'numrange' => { 'name' => 'numrange', 'type' => 'numrange', 'label' => 'Numrange' },
          'password' => { 'name' => 'password', 'type' => 'string', 'label' => 'Password' },
          'path' => { 'name' => 'path', 'type' => 'path', 'label' => 'Path' },
          'point' => { 'name' => 'point', 'type' => 'point', 'label' => 'Point' },
          'polygon' => { 'name' => 'polygon', 'type' => 'polygon', 'label' => 'Polygon' },
          'serial' => { 'name' => 'serial', 'type' => 'integer', 'label' => 'Serial' },
          'string' => { 'name' => 'string', 'type' => 'string', 'label' => 'String' },
          'text' => { 'name' => 'text', 'type' => 'text', 'label' => 'Text' },
          'time' => { 'name' => 'time', 'type' => 'time', 'label' => 'Time' },
          'tsrange' => { 'name' => 'tsrange', 'type' => 'tsrange', 'label' => 'Tsrange' },
          'tstzrange' => { 'name' => 'tstzrange', 'type' => 'tstzrange', 'label' => 'Tstzrange' },
          'tsvector' => { 'name' => 'tsvector', 'type' => 'tsvector', 'label' => 'Tsvector' },
          'uuid' => { 'name' => 'uuid', 'type' => 'uuid', 'label' => 'Uuid' },
          'xml' => { 'name' => 'xml', 'type' => 'xml', 'label' => 'Xml' }
        )

        expect(subject.fields).to be_frozen
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
        expect(subject.index_fields).to be_a ::ActiveSupport::HashWithIndifferentAccess
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
        expect(subject.show_fields).to be_a ::ActiveSupport::HashWithIndifferentAccess
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
        expect(subject.form_fields).to be_a ::ActiveSupport::HashWithIndifferentAccess
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
        expect(subject.index_field_names).to eq %w(id bigint bigserial bit bit_varying boolean box cidr circle color date daterange datetime decimal email float inet int4range int8range integer line lseg ltree macaddr money numrange password path point polygon serial string time tsrange tstzrange uuid)
      end
    end

    describe '#show_field_names' do
      it 'includes all field names' do
        expect(subject.show_field_names).to eq %w(id bigint bigserial binary bit bit_varying boolean box cidr circle citext color date daterange datetime decimal email float hstore inet int4range int8range integer json jsonb line lseg ltree macaddr money numrange password path point polygon serial string text time tsrange tstzrange tsvector uuid xml)
      end
    end

    describe '#form_field_names' do
      it 'excludes id, created_at, updated_at, has_scope and is_through fields' do
        expect(subject.form_field_names).to eq %w(bigint bigserial binary bit bit_varying boolean box cidr circle citext color date daterange datetime decimal email float hstore inet int4range int8range integer json jsonb line lseg ltree macaddr money numrange password path point polygon serial string text time tsrange tstzrange tsvector uuid xml)
        expect(subject.form_field_names).not_to include 'id'
        expect(subject.form_field_names).not_to include 'created_at'
        expect(subject.form_field_names).not_to include 'updated_at'
      end
    end

    describe '#index_type_of' do
      it 'returns the type' do
        expect(subject.index_type_of('id')).to eq 'integer'
        expect { subject.index_type_of('unknown') }.to raise_error ArgumentError
      end
    end

    describe '#show_type_of' do
      it 'returns the type' do
        expect(subject.show_type_of('id')).to eq 'integer'
        expect { subject.show_type_of('unknown') }.to raise_error ArgumentError
      end
    end

    describe '#form_type_of' do
      it 'returns the type' do
        expect(subject.form_type_of('id')).to eq 'integer'
        expect { subject.form_type_of('unknown') }.to raise_error ArgumentError
      end
    end
  end

  describe 'Association fields' do
    let(:model_class) { Product }
    describe '#fields' do
      it 'returns a hash of all keys' do
        expect(subject.fields.select { |_k, v| v['is_association'] }).to eq(
          'product_detail' => { 'name' => 'product_detail', 'type' => 'has_one', 'label' => 'Product detail', 'is_association' => true, 'is_through' => false, 'has_scope' => false, 'foreign_key' => 'product_detail_id', 'class' => ProductDetail },
          'picture' => { 'name' => 'picture', 'type' => 'has_one', 'label' => 'Picture', 'is_association' => true, 'is_through' => false, 'has_scope' => true, 'foreign_key' => 'picture_id', 'class' => Picture },
          'order_items' => { 'name' => 'order_items', 'type' => 'has_many', 'label' => 'Order items', 'is_association' => true, 'is_through' => false, 'has_scope' => false, 'foreign_key' => 'order_item_ids', 'class' => Order::Item },
          'orders' => { 'name' => 'orders', 'type' => 'has_many', 'label' => 'Orders', 'is_association' => true, 'is_through' => true, 'has_scope' => false, 'foreign_key' => 'order_ids', 'class' => Order },
          'category' => { 'name' => 'category', 'type' => 'belongs_to', 'label' => 'Category', 'is_association' => true, 'is_through' => false, 'has_scope' => false, 'foreign_key' => 'category_id', 'class' => Category },
          'tags' => { 'name' => 'tags', 'type' => 'has_and_belongs_to_many', 'label' => 'Tags', 'is_association' => true, 'is_through' => false, 'has_scope' => false, 'foreign_key' => 'tag_ids', 'class' => Tag }
        )
      end
    end

    describe '#index_field_names' do
      it 'excludes fields that have long value' do
        expect(subject.index_field_names).to eq %w(id sku name stock price featured available_to_date available_to_time published_at)
      end
    end

    describe '#form_field_names' do
      it 'excludes id, created_at, updated_at, has_scope and is_through fields' do
        expect(subject.form_field_names).to eq %w(sku name description stock price featured available_to_date available_to_time published_at product_detail order_items category tags)
      end
    end

    describe '#foreign_keys_from_associations' do
      it 'returns foreign keys for associations' do
        expect(subject.send(:foreign_keys_from_associations)).to eq %w(product_detail_id picture_id order_item_ids order_ids category_id tag_ids)
      end
    end
  end

  describe 'Polymorphic fields' do
    let(:model_class) { Picture }
    describe '#fields' do
      it 'returns a hash of all keys' do
        expect(subject.fields).to eq(
          'id' => {
            'name' => 'id', 'type' => 'integer', 'label' => 'Id'
          },
          'name' => {
            'name' => 'name', 'type' => 'string', 'label' => 'Name'
          },
          'file' => {
            'name' => 'file', 'type' => 'binary', 'label' => 'File'
          },
          'created_at' => {
            'name' => 'created_at', 'type' => 'datetime', 'label' => 'Created at'
          },
          'updated_at' => {
            'name' => 'updated_at', 'type' => 'datetime', 'label' => 'Updated at'
          },
          'imageable' => {
            'name' => 'imageable', 'type' => 'belongs_to', 'label' => 'Imageable', 'is_association' => true, 'is_polymorphic' => true, 'is_through' => false, 'has_scope' => false, 'foreign_key' => 'imageable_id', 'polymorphic_type' => 'imageable_type', 'polymorphic_list' => [Product]
          }
        )
      end
    end

    describe '#index_field_names' do
      it 'excludes fields that have long value' do
        expect(subject.index_field_names).to eq %w(id name created_at updated_at)
      end
    end

    describe '#form_field_names' do
      it 'excludes id, created_at, updated_at, has_scope and is_through fields' do
        expect(subject.form_field_names).to eq %w(name file imageable)
      end
    end

    describe '#foreign_keys_from_associations' do
      it 'returns ploymorphic foreign keys for associations' do
        expect(subject.send(:foreign_keys_from_associations)).to eq %w(imageable_id imageable_type)
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
