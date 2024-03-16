# frozen_string_literal: true

require 'rails_helper'

describe Wallaby::Map::ModeMapper do
  describe '.execute' do
    context 'when class_names are blank' do
      it 'returns empty hash' do
        expect(described_class.execute(nil)).to be_a Wallaby::ClassHash
        expect(described_class.execute(nil)).to eq({})

        expect(described_class.execute([])).to be_a Wallaby::ClassHash
        expect(described_class.execute([])).to eq({})
      end
    end

    context 'when class_names are not blank' do
      before do
        Wallaby.configuration.custom_models = [Array, Hash]
      end

      it 'returns a mode map' do
        expect(described_class.execute([Wallaby::Custom])).to be_a Wallaby::ClassHash
        expect(described_class.execute([Wallaby::Custom])).to eq \
          Array => Wallaby::Custom,
          Hash => Wallaby::Custom
      end
    end
  end
end
