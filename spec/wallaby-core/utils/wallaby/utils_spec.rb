# frozen_string_literal: true

require 'rails_helper'

describe Wallaby::Utils do
  describe '.clone' do
    it 'clones object' do
      object = 'Post'
      expect(described_class.clone(object)).to eq object
      expect(described_class.clone(object).object_id).not_to eq object.object_id
    end

    context 'when hash' do
      it 'clones object' do
        object = { a: 1 }
        expect(described_class.clone(object)).to eq object
        expect(described_class.clone(object)[:a]).to eq object[:a]
        expect(described_class.clone(object).object_id).not_to eq object.object_id
      end
    end

    context 'when hash with static default' do
      it 'clones object' do
        object = { a: 1 }
        object.default = 2
        expect(described_class.clone(object)).to eq object
        expect(described_class.clone(object)[:a]).to eq object[:a]
        expect(described_class.clone(object).default).to eq object.default
        expect(described_class.clone(object).object_id).not_to eq object.object_id

        object.default = ({})
        expect(described_class.clone(object)).to eq object
        expect(described_class.clone(object)[:a]).to eq object[:a]
        expect(described_class.clone(object)[:unknown]).to eq object[:unknown]
        expect(described_class.clone(object)[:unknown].object_id).to eq object[:unknown].object_id
        expect(described_class.clone(object).default).to eq object.default
        expect(described_class.clone(object).object_id).not_to eq object.object_id
      end
    end

    context 'when HashWithIndifferentAccess' do
      it 'clones object' do
        object = { a: 1 }.with_indifferent_access
        expect(described_class.clone(object)).to eq object
        expect(described_class.clone(object)[:a]).to eq object[:a]
        expect(described_class.clone(object).object_id).not_to eq object.object_id
      end
    end

    context 'when HashWithIndifferentAccess with static default' do
      it 'clones object' do
        object = { a: 1 }.with_indifferent_access
        object.default = 2
        expect(described_class.clone(object)).to eq object
        expect(described_class.clone(object)[:a]).to eq object[:a]
        expect(described_class.clone(object).default).to eq object.default
        expect(described_class.clone(object).object_id).not_to eq object.object_id

        object.default = ({})
        expect(described_class.clone(object)).to eq object
        expect(described_class.clone(object)[:a]).to eq object[:a]
        expect(described_class.clone(object)[:unknown]).to eq object[:unknown]
        expect(described_class.clone(object)[:unknown].object_id).to eq object[:unknown].object_id
        expect(described_class.clone(object).default).to eq object.default
        expect(described_class.clone(object).object_id).not_to eq object.object_id
      end
    end

    context 'when HashWithIndifferentAccess with dynamic default' do
      it 'clones object' do
        object = Hash.new { |hash, key| hash[key] = {} }.with_indifferent_access
        expect(described_class.clone(object)[:unknown]).to eq object[:unknown]
        expect(described_class.clone(object)[:unknown].object_id).not_to eq object[:unknown].object_id
        expect(described_class.clone(object).default).to eq object.default
        expect(described_class.clone(object).object_id).not_to eq object.object_id
      end
    end

    context 'when array' do
      it 'clones object' do
        object = ['a']
        expect(described_class.clone(object)).to eq object
        expect(described_class.clone(object)[0]).to eq object[0]
        expect(described_class.clone(object)[0].object_id).not_to eq object[0].object_id
        expect(described_class.clone(object).object_id).not_to eq object.object_id
      end
    end

    context 'when class' do
      it 'clones object' do
        object = String
        expect(described_class.clone(object)).to eq object
        expect(described_class.clone(object).object_id).to eq object.object_id
      end
    end

    context 'when object' do
      it 'clones object' do
        object = AllPostgresType.create text: 'test'
        expect(described_class.clone(object)).not_to eq object
        expect(described_class.clone(object).object_id).not_to eq object.object_id
        expect(described_class.clone(object).id).to be_nil
        expect(described_class.clone(object).attributes.except('id')).to eq object.attributes.except('id')
      end
    end
  end

  describe '.inspect' do
    it 'returns filter name' do
      expect(described_class.inspect(nil)).to eq 'nil'
      expect(described_class.inspect(false)).to eq 'false'
      expect(described_class.inspect(Person.new(id: 1))).to eq 'Person#1'
    end
  end
end
