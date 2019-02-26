require 'rails_helper'

describe Wallaby::Utils do
  describe '.translate_class' do
    it 'translates a message for a method' do
      expect(described_class.translate_class(Wallaby::Map::ModelClassMapper.new, :missing_model_class, model: Product)).to eq "[WALLABY] Please define self.model_class for Product or set it as global.\n          @see Wallaby.configuration.mapping"
      expect(described_class.translate_class(Wallaby::Map::ModelClassMapper, :missing_model_class, model: Product)).to eq "[WALLABY] Please define self.model_class for Product or set it as global.\n          @see Wallaby.configuration.mapping"
    end
  end

  describe '.to_field_label' do
    it 'returns label' do
      expect(described_class.to_field_label(:something, {})).to eq 'Something'
      expect(described_class.to_field_label(:something, label: 'Else')).to eq 'Else'
    end
  end
end
