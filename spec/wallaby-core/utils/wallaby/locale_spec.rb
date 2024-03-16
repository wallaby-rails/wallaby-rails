# frozen_string_literal: true

require 'rails_helper'

describe Wallaby::Locale do
  describe '.t' do
    it 'returns translation' do
      expect(described_class.t('wallaby.labels.count')).to eq 'Count: '
      expect(described_class.t('labels.count')).to eq 'Count: '
      expect(described_class.t('count', default: 'Count: ')).to eq 'Count: '
      expect(described_class.t('count', default: ['labels.count', 'Check'])).to eq 'Count: '
      expect(described_class.t('count', default: ['test.count', :'labels.count'])).to eq 'Count: '
    end

    context 'when translation is not under wallaby namespace' do
      it 'returns translation' do
        expect(described_class.t('hello')).to eq 'Hello world'
      end
    end

    context 'when translation is missing' do
      it 'returns missing translation' do
        expect(described_class.t('unknown')).to match(/^translation missing/i)
      end
    end
  end
end
