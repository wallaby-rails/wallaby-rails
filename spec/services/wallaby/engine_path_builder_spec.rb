require 'rails_helper'

describe Wallaby::EnginePathBuilder, type: :helper do
  let(:default_url_options) { { some: 'thing' } }
  describe '.handle' do
    context 'when action is index/create' do
      it 'returns resources_path' do
        %w(index create).each do |action|
          expect(described_class.handle(engine_name: 'wallaby_engine', parameters: { resources: 'products', action: action }, default_url_options: default_url_options)).to eq '/admin/products?some=thing'
          expect(described_class.handle(engine_name: 'wallaby_engine', parameters: parameters(resources: 'products', action: action), default_url_options: default_url_options)).to eq '/admin/products?some=thing'
        end
      end
    end

    context 'when action is new' do
      it 'returns new_resource_path' do
        expect(described_class.handle(engine_name: 'wallaby_engine', parameters: { resources: 'products', action: 'new' }, default_url_options: default_url_options)).to eq '/admin/products/new?some=thing'
        expect(described_class.handle(engine_name: 'wallaby_engine', parameters: parameters(resources: 'products', action: 'new'), default_url_options: default_url_options)).to eq '/admin/products/new?some=thing'
      end
    end

    context 'when action is edit' do
      it 'returns edit_resource_path' do
        expect(described_class.handle(engine_name: 'wallaby_engine', parameters: { resources: 'products', action: 'edit', id: 1 }, default_url_options: default_url_options)).to eq '/admin/products/1/edit?some=thing'
        expect(described_class.handle(engine_name: 'wallaby_engine', parameters: parameters!(resources: 'products', action: 'edit', id: 1), default_url_options: default_url_options)).to eq '/admin/products/1/edit?some=thing'
      end
    end

    context 'when action is show/update/destroy' do
      it 'returns resource_path' do
        %w(show update destroy).each do |action|
          expect(described_class.handle(engine_name: 'wallaby_engine', parameters: { resources: 'products', action: action, id: 1 }, default_url_options: default_url_options)).to eq '/admin/products/1?some=thing'
          expect(described_class.handle(engine_name: 'wallaby_engine', parameters: parameters!(resources: 'products', action: action, id: 1), default_url_options: default_url_options)).to eq '/admin/products/1?some=thing'
        end
      end
    end

    context 'when options contains only_path' do
      it 'excludes only_path' do
        %w(index create new edit show update destroy).each do |action|
          expect(described_class.handle(engine_name: 'wallaby_engine', parameters: { resources: 'products', id: 1, action: action, only_path: false })).not_to match %r{://[^/]+/}
          expect(described_class.handle(engine_name: 'wallaby_engine', parameters: parameters!(resources: 'products', id: 1, action: action, only_path: false))).not_to match %r{://[^/]+/}
        end
      end
    end
  end
end
