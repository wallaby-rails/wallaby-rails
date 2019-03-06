require 'rails_helper'

describe Wallaby::Map::ModelClassMapper do
  describe '#map' do
    it 'returns empty hash' do
      expect(described_class.map(nil)).to eq({})
      expect(described_class.map([])).to eq({})
    end

    context 'when base class is not empty' do
      before do
        class PretendToBeABaseClass
          class SubClass1 < self
            def self.model_class; :AModelClass; end
          end

          class SubClass2 < self
            def self.model_class; :BModelClass; end
          end

          class AbstractClass < self
            def self.base_class?; true; end
          end

          class AnonymousClass < self
            def self.name; nil; end
          end
        end
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
