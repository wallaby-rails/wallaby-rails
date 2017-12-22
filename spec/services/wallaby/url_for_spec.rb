require 'rails_helper'

describe Wallaby::UrlFor, type: :helper do
  describe '.handle' do
    context 'when action is index/create' do
      it 'returns resources_path' do
        %w(index create).each do |action|
          expect(described_class.handle(helper.wallaby_engine, resources: 'products', action: action)).to eq '/admin/products'
          expect(described_class.handle(helper.wallaby_engine, parameters(resources: 'products', action: action))).to eq '/admin/products'
        end
      end
    end

    context 'when action is new' do
      it 'returns new_resource_path' do
        expect(described_class.handle(helper.wallaby_engine, resources: 'products', action: 'new')).to eq '/admin/products/new'
        expect(described_class.handle(helper.wallaby_engine, parameters(resources: 'products', action: 'new'))).to eq '/admin/products/new'
      end
    end

    context 'when action is edit' do
      it 'returns edit_resource_path' do
        expect(described_class.handle(helper.wallaby_engine, resources: 'products', action: 'edit', id: 1)).to eq '/admin/products/1/edit'
        expect(described_class.handle(helper.wallaby_engine, parameters!(resources: 'products', action: 'edit', id: 1))).to eq '/admin/products/1/edit'
      end
    end

    context 'when action is show/update/destroy' do
      it 'returns resource_path' do
        %w(show update destroy).each do |action|
          expect(described_class.handle(helper.wallaby_engine, resources: 'products', action: action, id: 1)).to eq '/admin/products/1'
          expect(described_class.handle(helper.wallaby_engine, parameters!(resources: 'products', action: action, id: 1))).to eq '/admin/products/1'
        end
      end
    end

    context 'when options contains only_path' do
      it 'excludes only_path' do
        %w(index create new edit show update destroy).each do |action|
          uri = URI(described_class.handle(helper.wallaby_engine, resources: 'products', id: 1, action: action, only_path: false))
          expect(uri.host).to be_blank

          uri = URI(described_class.handle(helper.wallaby_engine, parameters!(resources: 'products', id: 1, action: action, only_path: false)))
          expect(uri.host).to be_blank
        end
      end
    end
  end
end
