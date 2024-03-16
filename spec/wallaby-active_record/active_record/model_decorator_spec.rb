# frozen_string_literal: true

require 'rails_helper'

describe Wallaby::ActiveRecord::ModelDecorator do
  subject { described_class.new model_class }

  let(:model_class) { AllPostgresType }

  describe 'General fields' do
    describe '#fields' do
      it 'returns a hash of all keys' do
        expect(subject.fields).to be_a ::ActiveSupport::HashWithIndifferentAccess

        if Rails::VERSION::MAJOR >= 5
          expect(subject.fields).to eq(
            'id' => { 'type' => 'integer', 'label' => 'Id' },
            'bigint' => { 'type' => 'integer', 'label' => 'Bigint' },
            'bigserial' => { 'type' => 'integer', 'label' => 'Bigserial' },
            'binary' => { 'type' => 'binary', 'label' => 'Binary' },
            'bit' => { 'type' => 'bit', 'label' => 'Bit' },
            'bit_varying' => { 'type' => 'bit_varying', 'label' => 'Bit varying' },
            'boolean' => { 'type' => 'boolean', 'label' => 'Boolean' },
            'box' => { 'type' => 'box', 'label' => 'Box' },
            'cidr' => { 'type' => 'cidr', 'label' => 'Cidr' },
            'circle' => { 'type' => 'circle', 'label' => 'Circle' },
            'citext' => { 'type' => 'citext', 'label' => 'Citext' },
            'color' => { 'type' => 'string', 'label' => 'Color' },
            'date' => { 'type' => 'date', 'label' => 'Date' },
            'daterange' => { 'type' => 'daterange', 'label' => 'Daterange' },
            'datetime' => { 'type' => 'datetime', 'label' => 'Datetime' },
            'decimal' => { 'type' => 'decimal', 'label' => 'Decimal' },
            'email' => { 'type' => 'string', 'label' => 'Email' },
            'float' => { 'type' => 'float', 'label' => 'Float' },
            'hstore' => { 'type' => 'hstore', 'label' => 'Hstore' },
            'inet' => { 'type' => 'inet', 'label' => 'Inet' },
            'int4range' => { 'type' => 'int4range', 'label' => 'Int4range' },
            'int8range' => { 'type' => 'int8range', 'label' => 'Int8range' },
            'integer' => { 'type' => 'integer', 'label' => 'Integer' },
            'json' => { 'type' => 'json', 'label' => 'Json' },
            'jsonb' => { 'type' => 'jsonb', 'label' => 'Jsonb' },
            'line' => { 'type' => 'line', 'label' => 'Line' },
            'lseg' => { 'type' => 'lseg', 'label' => 'Lseg' },
            'ltree' => { 'type' => 'ltree', 'label' => 'Ltree' },
            'macaddr' => { 'type' => 'macaddr', 'label' => 'Macaddr' },
            'money' => { 'type' => 'money', 'label' => 'Money' },
            'numrange' => { 'type' => 'numrange', 'label' => 'Numrange' },
            'password' => { 'type' => 'string', 'label' => 'Password' },
            'path' => { 'type' => 'path', 'label' => 'Path' },
            'point' => { 'type' => 'point', 'label' => 'Point' },
            'polygon' => { 'type' => 'polygon', 'label' => 'Polygon' },
            'serial' => { 'type' => 'integer', 'label' => 'Serial' },
            'string' => { 'type' => 'string', 'label' => 'String' },
            'text' => { 'type' => 'text', 'label' => 'Text' },
            'time' => { 'type' => 'time', 'label' => 'Time' },
            'tsrange' => { 'type' => 'tsrange', 'label' => 'Tsrange' },
            'tstzrange' => { 'type' => 'tstzrange', 'label' => 'Tstzrange' },
            'tsvector' => { 'type' => 'tsvector', 'label' => 'Tsvector' },
            'uuid' => { 'type' => 'uuid', 'label' => 'Uuid' },
            'xml' => { 'type' => 'xml', 'label' => 'Xml' }
          )
        elsif Rails::VERSION::MAJOR == 4
          expect(subject.fields).to eq(
            'id' => { 'type' => 'integer', 'label' => 'Id' },
            'bigint' => { 'type' => 'integer', 'label' => 'Bigint' },
            'binary' => { 'type' => 'binary', 'label' => 'Binary' },
            'bit' => { 'type' => 'bit', 'label' => 'Bit' },
            'bit_varying' => { 'type' => 'bit_varying', 'label' => 'Bit varying' },
            'boolean' => { 'type' => 'boolean', 'label' => 'Boolean' },
            'cidr' => { 'type' => 'cidr', 'label' => 'Cidr' },
            'citext' => { 'type' => 'citext', 'label' => 'Citext' },
            'color' => { 'type' => 'string', 'label' => 'Color' },
            'date' => { 'type' => 'date', 'label' => 'Date' },
            'daterange' => { 'type' => 'daterange', 'label' => 'Daterange' },
            'datetime' => { 'type' => 'datetime', 'label' => 'Datetime' },
            'decimal' => { 'type' => 'decimal', 'label' => 'Decimal' },
            'email' => { 'type' => 'string', 'label' => 'Email' },
            'float' => { 'type' => 'float', 'label' => 'Float' },
            'hstore' => { 'type' => 'hstore', 'label' => 'Hstore' },
            'inet' => { 'type' => 'inet', 'label' => 'Inet' },
            'int4range' => { 'type' => 'int4range', 'label' => 'Int4range' },
            'int8range' => { 'type' => 'int8range', 'label' => 'Int8range' },
            'integer' => { 'type' => 'integer', 'label' => 'Integer' },
            'json' => { 'type' => 'json', 'label' => 'Json' },
            'jsonb' => { 'type' => 'jsonb', 'label' => 'Jsonb' },
            'ltree' => { 'type' => 'ltree', 'label' => 'Ltree' },
            'macaddr' => { 'type' => 'macaddr', 'label' => 'Macaddr' },
            'money' => { 'type' => 'money', 'label' => 'Money' },
            'numrange' => { 'type' => 'numrange', 'label' => 'Numrange' },
            'password' => { 'type' => 'string', 'label' => 'Password' },
            'string' => { 'type' => 'string', 'label' => 'String' },
            'text' => { 'type' => 'text', 'label' => 'Text' },
            'time' => { 'type' => 'time', 'label' => 'Time' },
            'tsrange' => { 'type' => 'tsrange', 'label' => 'Tsrange' },
            'tstzrange' => { 'type' => 'tstzrange', 'label' => 'Tstzrange' },
            'tsvector' => { 'type' => 'tsvector', 'label' => 'Tsvector' },
            'uuid' => { 'type' => 'uuid', 'label' => 'Uuid' },
            'xml' => { 'type' => 'xml', 'label' => 'Xml' }
          )
        end

        expect(subject.fields).to be_frozen
      end

      context 'when model table does not exist' do
        let(:model_class) { stub_const('UnknowLand', Class.new(ActiveRecord::Base)) }

        shared_examples_for 'returning empty hash' do
          specify do
            expect { subject.fields }.not_to raise_error
            expect(subject.fields).to eq(ActiveSupport::HashWithIndifferentAccess.new)
            expect(subject.fields.default).to eq({})
            expect(subject.fields[:unknown]).to eq({})
          end
        end

        it_behaves_like 'returning empty hash'

        context 'when database does not exist' do
          before do
            allow(model_class).to receive(:table_exists?).and_raise(ActiveRecord::NoDatabaseError)
          end

          it_behaves_like 'returning empty hash'
        end
      end
    end

    describe '#index_fields' do
      it 'has same value as fields' do
        expect(subject.index_fields).to be_a ::ActiveSupport::HashWithIndifferentAccess
        expect(subject.index_fields).to eq subject.fields
      end

      context 'when changing index_fields' do
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

      context 'when changing show_fields' do
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

      context 'when changing form_fields' do
        it 'doesnt modify fields' do
          expect { subject.form_fields['id'][:label] = 'ID' }.not_to(change { subject.fields['id'][:label] })
        end
      end
    end

    describe '#index_field_names' do
      it 'excludes fields that have long value' do
        if Rails::VERSION::MAJOR >= 5
          expect(subject.index_field_names).to match_array %w[id bigint bigserial bit bit_varying boolean box cidr circle color date daterange datetime decimal email float inet int4range int8range integer line lseg ltree macaddr money numrange password path point polygon serial string time tsrange tstzrange uuid]
        elsif Rails::VERSION::MAJOR == 4
          expect(subject.index_field_names).to match_array %w[id bigint bit bit_varying boolean cidr color date daterange datetime decimal email float inet int4range int8range integer ltree macaddr money numrange password string time tsrange tstzrange uuid]
        end
      end
    end

    describe '#show_field_names' do
      it 'includes all field names' do
        if Rails::VERSION::MAJOR >= 5
          expect(subject.show_field_names).to match_array %w[id bigint bigserial binary bit bit_varying boolean box cidr circle citext color date daterange datetime decimal email float hstore inet int4range int8range integer json jsonb line lseg ltree macaddr money numrange password path point polygon serial string text time tsrange tstzrange tsvector uuid xml]
        elsif Rails::VERSION::MAJOR == 4
          expect(subject.show_field_names).to match_array %w[id bigint binary bit bit_varying boolean cidr citext color date daterange datetime decimal email float hstore inet int4range int8range integer json jsonb ltree macaddr money numrange password string text time tsrange tstzrange tsvector uuid xml]
        end
      end
    end

    describe '#form_field_names' do
      it 'excludes id, created_at, updated_at, has_scope and is_through fields' do
        if Rails::VERSION::MAJOR >= 5
          expect(subject.form_field_names).to match_array %w[bigint bigserial binary bit bit_varying boolean box cidr circle citext color date daterange datetime decimal email float hstore inet int4range int8range integer json jsonb line lseg ltree macaddr money numrange password path point polygon serial string text time tsrange tstzrange tsvector uuid xml]
        elsif Rails::VERSION::MAJOR == 4
          expect(subject.form_field_names).to match_array %w[bigint binary bit bit_varying boolean cidr citext color date daterange datetime decimal email float hstore inet int4range int8range integer json jsonb ltree macaddr money numrange password string text time tsrange tstzrange tsvector uuid xml]
        end

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
          'product_detail' => { 'type' => 'has_one', 'label' => 'Product detail', 'is_association' => true, 'sort_disabled' => true, 'is_through' => false, 'has_scope' => false, 'foreign_key' => 'product_detail_id', 'class' => ProductDetail },
          'picture' => { 'type' => 'has_one', 'label' => 'Picture', 'is_association' => true, 'sort_disabled' => true, 'is_through' => false, 'has_scope' => true, 'foreign_key' => 'picture_id', 'class' => Picture },
          'order_items' => { 'type' => 'has_many', 'label' => 'Order items', 'is_association' => true, 'sort_disabled' => true, 'is_through' => false, 'has_scope' => false, 'foreign_key' => 'order_item_ids', 'class' => Order::Item },
          'orders' => { 'type' => 'has_many', 'label' => 'Orders', 'is_association' => true, 'sort_disabled' => true, 'is_through' => true, 'has_scope' => false, 'foreign_key' => 'order_ids', 'class' => Order },
          'category' => { 'type' => 'belongs_to', 'label' => 'Category', 'is_association' => true, 'sort_disabled' => true, 'is_through' => false, 'has_scope' => false, 'foreign_key' => 'category_id', 'class' => Category },
          'tags' => { 'type' => 'has_and_belongs_to_many', 'label' => 'Tags', 'is_association' => true, 'sort_disabled' => true, 'is_through' => false, 'has_scope' => false, 'foreign_key' => 'tag_ids', 'class' => Tag }
        )
      end
    end

    describe '#index_field_names' do
      it 'excludes fields that have long value' do
        expect(subject.index_field_names).to match_array %w[id sku name stock price featured available_to_date available_to_time published_at]
      end
    end

    describe '#form_field_names' do
      it 'excludes id, created_at, updated_at, has_scope and is_through fields' do
        expect(subject.form_field_names).to match_array %w[sku name description stock price featured available_to_date available_to_time published_at product_detail order_items category tags]
      end
    end
  end

  describe 'Polymorphic fields' do
    let(:model_class) { Picture }

    describe '#fields' do
      it 'returns a hash of all keys' do
        expect(subject.fields).to eq(
          'id' => {
            'type' => 'integer', 'label' => 'Id'
          },
          'name' => {
            'type' => 'string', 'label' => 'Name'
          },
          'file' => {
            'type' => 'binary', 'label' => 'File'
          },
          'created_at' => {
            'type' => 'datetime', 'label' => 'Created at'
          },
          'updated_at' => {
            'type' => 'datetime', 'label' => 'Updated at'
          },
          "imageable_id" => { "hidden" => true, "is_foreign_key" => true, "label" => "Imageable", "type" => "integer" },
          "imageable_type" => { "hidden" => true, "is_polymorphic_type" => true, "label" => "Imageable type", "type" => "string" },
          'imageable' => {
            'type' => 'belongs_to', 'label' => 'Imageable', 'is_association' => true, 'sort_disabled' => true, 'is_polymorphic' => true, 'is_through' => false, 'has_scope' => false, 'foreign_key' => 'imageable_id', 'polymorphic_type' => 'imageable_type',
            'polymorphic_list' => [Product]
          }
        )
      end
    end

    describe '#index_field_names' do
      it 'excludes fields that have long value' do
        expect(subject.index_field_names).to match_array %w[id name created_at updated_at]
      end
    end

    describe '#form_field_names' do
      it 'excludes id, created_at, updated_at, has_scope and is_through fields' do
        expect(subject.form_field_names).to match_array %w[name file imageable]
      end
    end
  end

  describe '#form_active_errors' do
    it 'returns the form errors' do
      resource = model_class.new
      resource.errors.add :name, 'cannot be nil'
      resource.errors.add :base, 'has error'
      expect(subject.form_active_errors(resource)).to be_a ActiveModel::Errors
      expect(subject.form_active_errors(resource).messages).to eq(
        name: ['cannot be nil'],
        base: ['has error']
      )
    end
  end

  describe '#primary_key' do
    it 'returns model primary_key' do
      allow(model_class).to receive(:primary_key).and_return('all_postgres_type_id')
      expect(subject.primary_key).to eq 'all_postgres_type_id'
    end

    context 'when primary key is nil' do
      it 'logs a warning message' do
        allow(model_class).to receive(:primary_key).and_return(nil)
        expect(Wallaby::Logger).to receive(:warn)

        subject.primary_key
      end
    end
  end

  describe '#guess_title' do
    it 'returns a label for the model' do
      resource = model_class.new string: "Fisherman's Friend"
      expect(subject.guess_title(resource)).to eq "Fisherman's Friend"
    end
  end
end
