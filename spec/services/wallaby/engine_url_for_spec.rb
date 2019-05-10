require 'rails_helper'

describe Wallaby::EngineUrlFor, type: :helper do
  describe '.handle' do
    let(:script_name) { '/admin' }
    before { wallaby_engine.default_url_options = { some: 'thing' } }
    context 'when action is index' do
      it 'returns resources_path' do
        %w(index).each do |action|
          expect(described_class.handle(engine: wallaby_engine, parameters: { resources: 'products', action: action }, script_name: script_name)).to eq '/admin/products?some=thing'
          expect(described_class.handle(engine: wallaby_engine, parameters: parameters!(resources: 'products', action: action), script_name: script_name)).to eq '/admin/products?some=thing'
        end
      end
    end

    context 'when action is new' do
      it 'returns new_resource_path' do
        expect(described_class.handle(engine: wallaby_engine, parameters: { resources: 'products', action: 'new' }, script_name: script_name)).to eq '/admin/products/new?some=thing'
        expect(described_class.handle(engine: wallaby_engine, parameters: parameters!(resources: 'products', action: 'new'), script_name: script_name)).to eq '/admin/products/new?some=thing'
      end
    end

    context 'when action is edit' do
      it 'returns edit_resource_path' do
        expect(described_class.handle(engine: wallaby_engine, parameters: { resources: 'products', action: 'edit', id: 1 }, script_name: script_name)).to eq '/admin/products/1/edit?some=thing'
        expect(described_class.handle(engine: wallaby_engine, parameters: parameters!(resources: 'products', action: 'edit', id: 1), script_name: script_name)).to eq '/admin/products/1/edit?some=thing'
      end
    end

    context 'when action is show' do
      it 'returns resource_path' do
        %w(show).each do |action|
          expect(described_class.handle(engine: wallaby_engine, parameters: { resources: 'products', action: action, id: 1 }, script_name: script_name)).to eq '/admin/products/1?some=thing'
          expect(described_class.handle(engine: wallaby_engine, parameters: parameters!(resources: 'products', action: action, id: 1), script_name: script_name)).to eq '/admin/products/1?some=thing'
        end
      end
    end

    context 'when options contains only_path' do
      it 'excludes only_path' do
        %w(index create new edit show update destroy).each do |action|
          expect(described_class.handle(engine: wallaby_engine, parameters: { resources: 'products', id: 1, action: action, only_path: false }, script_name: script_name)).not_to match %r{://[^/]+/}
          expect(described_class.handle(engine: wallaby_engine, parameters: parameters!(resources: 'products', id: 1, action: action, only_path: false), script_name: script_name)).not_to match %r{://[^/]+/}
        end
      end
    end
  end
end
