# frozen_string_literal: true

require 'rails_helper'

describe Wallaby::Map do
  describe '.mode_map' do
    before do
      described_class.modes = [Wallaby::Custom]
      Wallaby.configuration.custom_models = [AllMysqlType, AllPostgresType, AllSqliteType]
    end

    it 'returns a map of model -> mode' do
      expect(described_class.mode_map).to be_a Wallaby::ClassHash
      expect(described_class.mode_map).to eq AllMysqlType => Wallaby::Custom, AllPostgresType => Wallaby::Custom, AllSqliteType => Wallaby::Custom
    end

    it 'is frozen' do
      expect { described_class.mode_map[Array] = Wallaby::Custom }.to raise_error(/can't modify frozen Hash/)
    end
  end

  describe '.model_class_map' do
    it 'returns a model class that convert from a resources name' do
      expect(described_class.model_class_map('products')).to eq Product
      expect(described_class.instance_variable_get(:@model_class_map)).to be_a Wallaby::ClassHash
    end
  end

  describe '.resources_name_map' do
    it 'returns a resources name that convert from a model class' do
      expect(described_class.resources_name_map(Product)).to eq 'products'
      expect(described_class.instance_variable_get(:@resources_name_map)).to be_a Wallaby::ClassHash
    end
  end

  describe 'providers' do
    describe '.model_decorator_map' do
      it 'returns a model decorator' do
        expect(described_class.model_decorator_map(Array, Wallaby::ResourceDecorator)).to be_nil
        expect(described_class.model_decorator_map(AllPostgresType, Wallaby::ResourceDecorator)).to be_a Wallaby::ActiveRecord::ModelDecorator
        expect(described_class.instance_variable_get(:@model_decorator_map)).to be_a Wallaby::ClassHash
      end
    end

    describe '.service_provider_map' do
      it 'returns a model service provider' do
        expect(described_class.service_provider_map(Array)).to be_nil
        expect(described_class.service_provider_map(AllPostgresType)).to eq Wallaby::ActiveRecord::ModelServiceProvider
        expect(described_class.instance_variable_get(:@service_provider_map)).to be_a Wallaby::ClassHash
      end
    end

    describe '.pagination_provider_map' do
      it 'returns a model pagination provider' do
        expect(described_class.pagination_provider_map(Array)).to be_nil
        expect(described_class.pagination_provider_map(AllPostgresType)).to eq Wallaby::ActiveRecord::ModelPaginationProvider
        expect(described_class.instance_variable_get(:@pagination_provider_map)).to be_a Wallaby::ClassHash
      end
    end

    describe '.authorizer_provider_map' do
      it 'returns a list of model authorization provider' do
        expect(described_class.authorizer_provider_map(Array)).to be_nil
        expect(described_class.authorizer_provider_map(AllPostgresType)).to eq('cancancan' => Wallaby::ActiveRecord::CancancanProvider, 'default' => Wallaby::ActiveRecord::DefaultProvider, 'pundit' => Wallaby::ActiveRecord::PunditProvider)
        expect(described_class.instance_variable_get(:@authorizer_provider_map)).to be_a Wallaby::ClassHash
      end
    end
  end

  describe 'regexp' do
    describe '.resources_regexp' do
      it 'returns a regexp' do
        expect(described_class.resources_regexp).to be_a Regexp
        expect(described_class.instance_variable_get(:@resources_regexp)).to be_a Regexp
      end

      it 'matches valid url' do
        expect(described_class.resources_regexp).to be_match('/admin/orders/items')
      end

      it 'does not match invalid url' do
        expect(described_class.resources_regexp).not_to be_match('/admin/unknown_model')
      end
    end

    describe '.id_regexp' do
      it 'returns a regexp' do
        expect(described_class.id_regexp).to be_a Regexp
        expect(described_class.instance_variable_get(:@id_regexp)).to be_a Regexp
      end

      it 'matches valid url' do
        expect(described_class.id_regexp).to be_match('/admin/orders/items/1')
        expect(described_class.id_regexp).to be_match('/admin/orders/items/not_integer_id')
        expect(described_class.id_regexp).to be_match('/admin/orders/items/1/edit')
        expect(described_class.id_regexp).to be_match('/admin/orders/items/1/unknown_action')
        expect(described_class.id_regexp).to be_match('/admin/orders/items/not_integer_id/edit')
        expect(described_class.id_regexp).to be_match('/admin/orders/items/not_integer_id/unknown_action')
        expect(described_class.id_regexp).to be_match('1')
        expect(described_class.id_regexp).to be_match('not_integer_id')
      end

      it 'does not match invalid url' do
        expect(described_class.id_regexp).not_to be_match('/admin/unknown_model')
        expect(described_class.id_regexp).not_to be_match('/admin/unknown_model/1')
        expect(described_class.id_regexp).not_to be_match('/admin/unknown_model/not_integer_id')
        expect(described_class.id_regexp).not_to be_match('/1')
        expect(described_class.id_regexp).not_to be_match('/not_integer_id')
      end
    end
  end
end
