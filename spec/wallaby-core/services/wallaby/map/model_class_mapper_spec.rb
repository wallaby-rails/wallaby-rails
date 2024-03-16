# frozen_string_literal: true

require 'rails_helper'

describe Wallaby::Map::ModelClassMapper do
  describe '#map' do
    it 'returns empty hash' do
      expect(described_class.map(nil)).to eq({})
      expect(described_class.map([])).to eq({})
    end

    context 'when base class is not empty' do
      before do
        stub_const('PretendToBeABaseClass', Class.new)
        stub_const('PretendToBeABaseClass::SubClass1', Class.new(PretendToBeABaseClass) do
          def self.model_class
            :AModelClass
          end
        end)
        stub_const('PretendToBeABaseClass::SubClass2', Class.new(PretendToBeABaseClass) do
          def self.model_class
            :BModelClass
          end
        end)
        stub_const('PretendToBeABaseClass::AbstractClass', Class.new(PretendToBeABaseClass) do
          def self.base_class?
            true
          end
        end)
        stub_const('PretendToBeABaseClass::AnonymousClass', Class.new(PretendToBeABaseClass) do
          def self.name
            nil
          end
        end)
      end

      it 'returns a mode map' do
        expect(described_class.map(PretendToBeABaseClass.descendants)).to eq \
          AModelClass: PretendToBeABaseClass::SubClass1,
          BModelClass: PretendToBeABaseClass::SubClass2
      end

      context 'when block is given' do
        it 'returns a map' do
          expect(described_class.map(PretendToBeABaseClass.descendants, &:model_class)).to eq \
            AModelClass: :AModelClass,
            BModelClass: :BModelClass
        end
      end
    end
  end
end
