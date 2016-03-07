require 'rails_helper'

describe Wallaby::ActiveRecord::ModelDecorator do
  subject { described_class.new model_class }
  let(:model_class) do
    Class.new ActiveRecord::Base do
      def self.name
        'Product'
      end
    end
  end

  describe '#collection' do
    it 'returns a query' do
      expect(subject.collection).to be_a ActiveRecord::Relation
      expect(subject.collection.where_values).to eq []
    end
  end

  describe '#find_or_initialize' do
    it 'finds the record by id' do
      resource = model_class.new
      allow(model_class).to receive_message_chain(:where, :first).and_return resource
      expect(resource).to receive :assign_attributes
      expect{ subject.find_or_initialize 1 }.not_to raise_error

      allow(model_class).to receive_message_chain(:where, :first).and_return(nil)
      expect{ subject.find_or_initialize 1 }.to raise_error Wallaby::ResourceNotFound
    end

    it 'builds a new record' do
      expect_any_instance_of(model_class).to receive :assign_attributes
      new_record = subject.find_or_initialize nil
      expect(new_record).to be_a model_class
      expect(new_record).to be_new_record
    end
  end

  describe '#fields' do
    it 'returns a hash of all keys' do
      expect(subject.fields).to eq({
        "id" => {
          :name=>"id", :type=>"integer", :label=>"Id"
        },
        "category_id" => {
          :name=>"category_id", :type=>"integer", :label=>"Category"
        },
        "sku" => {
          :name=>"sku", :type=>"string", :label=>"Sku"
        },
        "name" => {
          :name=>"name", :type=>"string", :label=>"Name"
        },
        "description" => {
          :name=>"description", :type=>"text", :label=>"Description"
        },
        "stock" => {
          :name=>"stock", :type=>"integer", :label=>"Stock"
        },
        "price" => {
          :name=>"price", :type=>"float", :label=>"Price"
        },
        "featured" => {
          :name=>"featured", :type=>"boolean", :label=>"Featured"
        },
        "available_to_date" => {
          :name=>"available_to_date", :type=>"date", :label=>"Available to date"
        },
        "available_to_time" => {
          :name=>"available_to_time", :type=>"time", :label=>"Available to time"
        },
        "published_at" => {
          :name=>"published_at", :type=>"datetime", :label=>"Published at"
        }
      })
    end
  end

  describe '#index_fields' do
    it 'has same value as fields' do
      expect(subject.index_fields).to eq subject.fields
    end

    context 'changing index_fields' do
      it 'doesnt modify fields' do
        expect{ subject.index_fields['id'][:label] = 'ID' }.not_to change{ subject.fields['id'][:label] }
      end
    end
  end

  describe '#show_fields' do
    it 'has same value as fields' do
      expect(subject.show_fields).to eq subject.fields
    end

    context 'changing show_fields' do
      it 'doesnt modify fields' do
        expect{ subject.show_fields['id'][:label] = 'ID' }.not_to change{ subject.fields['id'][:label] }
      end
    end
  end

  describe '#form_fields' do
    it 'has same value as fields' do
      expect(subject.form_fields).to eq subject.fields
    end

    context 'changing form_fields' do
      it 'doesnt modify fields' do
        expect{ subject.form_fields['id'][:label] = 'ID' }.not_to change{ subject.fields['id'][:label] }
      end
    end
  end

  describe '#index_field_names' do
    it 'excludes associations, text, and binary fields' do
      associations = {
        'has_many' => { is_association: true },
        'description' => { type: 'text' },
        'sku' => { type: 'string' },
        'file' => { type: 'binary' }
      }
      allow(subject).to receive(:index_fields).and_return(associations)
      expect(subject.index_field_names).to eq %w( sku )
    end
  end

  describe '#form_field_names' do
    it 'excludes associations, text, and binary fields' do
      associations = {
        'id' => { type: 'integer' },
        'sku' => { type: 'string' },
        'has_one' => { type: 'has_one', },
        'has_many' => { type: 'has_many', has_scope: true },
        'has_and_belongs_to_many' => { type: 'has_and_belongs_to_many', is_through: true },
        'updated_at' => { type: 'datetime' },
        'created_at' => { type: 'datetime' }
      }
      allow(subject).to receive(:form_fields).and_return(associations)
      expect(subject.form_field_names).to eq %w( sku )
    end
  end

  describe '#form_require_name' do
    let(:model_class) do
      Class.new ActiveRecord::Base do
        def self.name
          'Order::Item'
        end
      end
    end

    it 'returns the require name for form' do
      expect(subject.form_require_name).to eq 'order_item'
    end
  end

  describe '#form_strong_param_names' do
    it 'returns the form strong param names' do
      expect(subject.form_strong_param_names).to eq ["category_id", "sku", "name", "description", "stock", "price", "featured", "available_to_date", "available_to_time", "published_at", {}]
    end
  end

  describe '#form_active_errors' do
    it 'returns the form errors' do
      resource = double errors: ActiveModel::Errors.new({})
      resource.errors.add :name, 'can not be nil'
      resource.errors.add :base, 'has error'
      expect(subject.form_active_errors resource).to eq({
        name: ['can not be nil'],
        base: ['has error']
      })
    end
  end

  describe '#primary_key' do
    it 'returns model primary_key' do
      allow(model_class).to receive(:primary_key).and_return('product_id')
      expect(subject.primary_key).to eq 'product_id'
    end
  end

  describe '#guess_title' do
    it 'returns a label for the model' do
      resource = double title: 'guessing'
      allow(subject).to receive(:title_field_finder).and_return(double find: 'title')
      expect(resource).to receive(:title)
      expect(subject.guess_title resource).to eq 'guessing'
    end
  end

  describe '#foreign_keys_from_associations' do
    context 'for general association fields' do
      it 'returns foreign keys for associations' do
        associations = {
          'general' => { foreign_key: 'category_id', polymorphic_type: nil }
        }
        expect(subject.send :foreign_keys_from_associations, associations).to eq %w( category_id )
      end
    end

    context 'for polymorphic association fields' do
      it 'returns foreign keys for associations' do
        associations = {
          'polymorphic' => { foreign_key: 'comment_id', polymorphic_type: 'comment_type' }
        }
        expect(subject.send :foreign_keys_from_associations, associations).to eq %w( comment_id comment_type )
      end
    end
  end

  describe '#many_associations' do
    context 'for non many associations' do
      it 'returns empty hash' do
        associations = {
          'belongs_to' => { type: 'belongs_to' },
          'has_one' => { type: 'has_one' }
        }
        expect(subject.send :many_associations, associations).to be_blank
      end
    end

    context 'for many associations' do
      it 'returns the many associations' do
        associations = {
          'has_many' => { type: 'has_many', is_through: false },
          'has_and_belongs_to_many' => { type: 'has_and_belongs_to_many', is_through: false },
          'has_many_through' => { type: 'has_many', is_through: true },
        }
        expect(subject.send(:many_associations, associations).keys).to eq %w( has_many has_and_belongs_to_many )
      end
    end
  end

  describe '#belongs_to_associations' do
    context 'for non belongs_to associations' do
      it 'returns empty hash' do
        associations = {
          'has_many' => { type: 'has_many' },
          'has_and_belongs_to_many' => { type: 'has_and_belongs_to_many' },
          'has_one' => { type: 'has_one' }
        }
        expect(subject.send :belongs_to_associations, associations).to be_blank
      end
    end

    context 'for belongs_to associations' do
      it 'returns the belongs_to associations' do
        associations = {
          'belongs_to' => { type: 'belongs_to' }
        }
        expect(subject.send(:belongs_to_associations, associations).keys).to eq %w( belongs_to )
      end
    end
  end

  describe '#general_form_field_names' do
    it 'includes belongs_to association foreign_key but excludes other association foreign keys' do
      associations = {
        'has_many' => { type: 'has_many', foreign_key: 'has_many_id' },
        'has_and_belongs_to_many' => { type: 'has_and_belongs_to_many', foreign_key: 'has_and_belongs_to_many_id' },
        'has_one' => { type: 'has_one', foreign_key: 'has_one_id' },
        'belongs_to' => { type: 'belongs_to', foreign_key: 'belongs_to_id' }
      }
      allow(subject).to receive(:association_fields).and_return(associations)
      expect(subject.send :general_form_field_names).to include 'belongs_to_id'
      expect(subject.send :general_form_field_names).not_to include 'has_many_id'
      expect(subject.send :general_form_field_names).not_to include 'has_and_belongs_to_many_id'
      expect(subject.send :general_form_field_names).not_to include 'has_one_id'
    end

    it 'excludes primary_key' do
      expect(subject.send :general_form_field_names).not_to include subject.primary_key
    end
  end

  describe '#many_association_form_params' do
    it 'returns a general params hash for many associations' do
      associations = {
        'has_many' => { type: 'has_many', foreign_key: 'has_many_id' },
        'has_and_belongs_to_many' => { type: 'has_and_belongs_to_many', foreign_key: 'has_and_belongs_to_many_id' }
      }
      expect(subject.send :many_association_form_params, associations, %w( has_many has_and_belongs_to_many )).to eq({
        "has_many_id" => [],
        "has_and_belongs_to_many_id" => []})
    end
  end
end
