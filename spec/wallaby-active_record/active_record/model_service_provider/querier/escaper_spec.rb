# frozen_string_literal: true

require 'rails_helper'

describe Wallaby::ActiveRecord::ModelServiceProvider::Querier::Escaper do
  describe '#execute' do
    it 'escapes percentage and underscore sign for LIKE query' do
      expect(described_class.execute('something_%else')).to eq('%something\_\%else%')
    end

    context 'when starting with %' do
      it 'escapes percentage and underscore sign for LIKE query' do
        expect(described_class.execute('%something_else')).to eq('%something\_else')
      end
    end

    context 'when starting with _' do
      it 'escapes percentage and underscore sign for LIKE query' do
        expect(described_class.execute('_something_else')).to eq('_something\_else')
      end
    end

    context 'when ending with %' do
      it 'escapes percentage and underscore sign for LIKE query' do
        expect(described_class.execute('something_else%')).to eq('something\_else%')
      end
    end

    context 'when ending with _' do
      it 'escapes percentage and underscore sign for LIKE query' do
        expect(described_class.execute('something_else_')).to eq('something\_else_')
      end
    end

    context 'when surrounding with %' do
      it 'escapes percentage and underscore sign for LIKE query' do
        expect(described_class.execute('%something_else%')).to eq('%something\_else%')
      end
    end

    context 'when surrounding with _' do
      it 'escapes percentage and underscore sign for LIKE query' do
        expect(described_class.execute('_something_else_')).to eq('_something\_else_')
      end
    end
  end
end
