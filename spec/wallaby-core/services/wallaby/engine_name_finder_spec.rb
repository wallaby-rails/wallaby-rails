# frozen_string_literal: true

require 'rails_helper'

describe Wallaby::EngineNameFinder do
  describe '.execute' do
    it 'returns the engine name' do
      expect(described_class.execute('/admin')).to eq 'wallaby_engine'
      expect(described_class.execute('/core/admin')).to eq 'core_nested_engine'
      expect(described_class.execute('/main/admin')).to eq 'main_engine'
      expect(described_class.execute('/admin_else')).to eq 'manager_engine'
      expect(described_class.execute('/inner')).to eq 'inner_engine'
    end

    context 'when engine name cannot be found' do
      it 'returns empty string' do
        expect(described_class.execute('')).to eq ''
        expect(described_class.execute('/unknown')).to eq ''
      end
    end
  end
end
