require 'rails_helper'

describe Wallaby::Custom::ModelDecorator do
  subject { described_class.new model_class }

  let(:model_class) { Postcode }

  describe '#fields' do
    it 'returns a hash of all keys' do
      expect(subject.fields).to be_a ::ActiveSupport::HashWithIndifferentAccess
      expect(subject.fields).to eq(
        'dc' => { 'type' => 'string', 'label' => 'Dc' },
        'id' => { 'type' => 'string', 'label' => 'Id' },
        'lat' => { 'label' => 'Lat', 'type' => 'string' },
        'locality' => { 'label' => 'Locality', 'type' => 'string' },
        'long' => { 'label' => 'Long', 'type' => 'string' },
        'postcode' => { 'label' => 'Postcode', 'type' => 'string' },
        'state' => { 'label' => 'State', 'type' => 'string' },
        'status' => { 'label' => 'Status', 'type' => 'string' },
        'type' => { 'label' => 'Type', 'type' => 'string' }
      )
      expect(subject.fields).to be_frozen
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
      expect(subject.index_field_names).to match_array %w(dc id lat locality long postcode state status type)
    end
  end

  describe '#show_field_names' do
    it 'includes all field names' do
      expect(subject.show_field_names).to match_array %w(dc id lat locality long postcode state status type)
    end
  end

  describe '#form_field_names' do
    it 'excludes id, created_at, updated_at, has_scope and is_through fields' do
      expect(subject.form_field_names).to match_array %w(dc lat locality long postcode state status type)
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
      resource = model_class.new
      expect(subject.form_active_errors(resource)).to be_a ActiveModel::Errors
    end
  end

  describe '#primary_key' do
    it 'returns model primary_key' do
      expect(subject.primary_key).to eq :id
    end
  end

  describe '#guess_title' do
    it 'returns a label for the model' do
      resource = model_class.new locality: "Fisherman's Friend"
      expect(subject.guess_title(resource)).to be_nil
    end
  end
end
