require 'rails_helper'

describe Wallaby::EngineNameFinder, type: :helper do
  describe '.find' do
    it 'returns the engine name' do
      expect(described_class.find('/admin')).to eq 'wallaby_engine'
      expect(described_class.find('/core/admin')).to eq 'core_nested_engine'
      expect(described_class.find('/main/admin')).to eq 'main_engine'
      expect(described_class.find('/admin_else')).to eq 'manager_engine'
      expect(described_class.find('/inner')).to eq 'inner_engine'
    end

    context 'when engine name cannot be found' do
      it 'returns empty string' do
        expect(described_class.find('')).to eq ''
        expect(described_class.find('/unknown')).to eq ''
      end
    end
  end
end
