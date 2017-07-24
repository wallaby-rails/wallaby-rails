require 'rails_helper'

describe Wallaby::Map::ModeMapper do
  describe '#map' do
    it 'returns empty hash' do
      expect(described_class.new(nil).map).to eq({})
      expect(described_class.new([]).map).to eq({})
    end

    context 'when mode classes are not empty' do
      before do
        class PretendToBeAMode
          class Finder
            def all; %i(ModelClass1 Modelclass2); end
          end

          def self.model_finder; Finder; end
        end
      end

      it 'returns a mode map' do
        expect(described_class.new([PretendToBeAMode]).map).to eq \
          ModelClass1: PretendToBeAMode,
          Modelclass2: PretendToBeAMode
      end
    end
  end
end
