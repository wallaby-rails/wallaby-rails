require 'rails_helper'

describe Wallaby::Her::ModelDecorator do
  subject { described_class.new model_class }
  let(:model_class) { Her::Product }

  describe '#fields' do
    it 'returns a hash of all keys' do
      expect(subject.fields).to be_a ::ActiveSupport::HashWithIndifferentAccess
      expect(subject.fields).to eq(
        'id'=>{'type'=>'string', 'label'=>'Id'},
        'sku'=>{'type'=>'string', 'label'=>'Sku'},
        'name'=>{'type'=>'string', 'label'=>'Name'},
        'picture'=>{'type'=>'has_one', 'label'=>'Picture', 'is_association'=>true, 'sort_disabled'=>true},
        'category'=>{'type'=>'belongs_to', 'label'=>'Category', 'is_association'=>true, 'sort_disabled'=>true},
        'orders'=>{'type'=>'has_many', 'label'=>'Orders', 'is_association'=>true, 'sort_disabled'=>true}
      )
      expect(subject.fields).to be_frozen
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
      expect(subject.index_field_names).to match_array %w(id sku name)
    end
  end

  describe '#show_field_names' do
    it 'includes all field names' do
      expect(subject.show_field_names).to match_array %w(id sku name picture category orders)
    end
  end

  describe '#form_field_names' do
    it 'excludes id, created_at, updated_at, has_scope and is_through fields' do
      expect(subject.form_field_names).to match_array %w(sku name)
      expect(subject.form_field_names).not_to include 'id'
    end
  end

  describe '#index_type_of' do
    it 'returns the type' do
      expect(subject.index_type_of('id')).to eq 'string'
      expect { subject.index_type_of('unknown') }.to raise_error ArgumentError
    end
  end

  describe '#show_type_of' do
    it 'returns the type' do
      expect(subject.show_type_of('id')).to eq 'string'
      expect { subject.show_type_of('unknown') }.to raise_error ArgumentError
    end
  end

  describe '#form_type_of' do
    it 'returns the type' do
      expect(subject.form_type_of('id')).to eq 'string'
      expect { subject.form_type_of('unknown') }.to raise_error ArgumentError
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
      allow(model_class).to receive(:primary_key).and_return('product_id')
      expect(subject.primary_key).to eq 'product_id'
    end
  end

  describe '#guess_title' do
    it 'returns a label for the model' do
      resource = model_class.new name: "Fisherman's Friend"
      expect(subject.guess_title(resource)).to eq "Fisherman's Friend"
    end
  end
end
