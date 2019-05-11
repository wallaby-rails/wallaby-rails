require 'rails_helper'

describe Wallaby::EngineUrlFor, type: :helper do
  describe '.handle' do
    context 'when action is index' do
      it 'returns resources_path' do
        %w(index).each do |action|
          expect(described_class.handle(engine_name: 'wallaby_engine', parameters: { resources: 'products', action: action })).to eq '/admin/products'
          expect(described_class.handle(engine_name: 'wallaby_engine', parameters: parameters!(resources: 'products', action: action))).to eq '/admin/products'
        end
      end
    end

    context 'when action is new' do
      it 'returns new_resource_path' do
        expect(described_class.handle(engine_name: 'wallaby_engine', parameters: { resources: 'products', action: 'new' })).to eq '/admin/products/new'
        expect(described_class.handle(engine_name: 'wallaby_engine', parameters: parameters!(resources: 'products', action: 'new'))).to eq '/admin/products/new'
      end
    end

    context 'when action is edit' do
      it 'returns edit_resource_path' do
        expect(described_class.handle(engine_name: 'wallaby_engine', parameters: { resources: 'products', action: 'edit', id: 1 })).to eq '/admin/products/1/edit'
        expect(described_class.handle(engine_name: 'wallaby_engine', parameters: parameters!(resources: 'products', action: 'edit', id: 1))).to eq '/admin/products/1/edit'
      end
    end

    context 'when action is show' do
      it 'returns resource_path' do
        %w(show).each do |action|
          expect(described_class.handle(engine_name: 'wallaby_engine', parameters: { resources: 'products', action: action, id: 1 })).to eq '/admin/products/1'
          expect(described_class.handle(engine_name: 'wallaby_engine', parameters: parameters!(resources: 'products', action: action, id: 1))).to eq '/admin/products/1'
        end
      end
    end
  end
end
