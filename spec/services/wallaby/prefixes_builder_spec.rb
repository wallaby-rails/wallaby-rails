require 'rails_helper'

describe Wallaby::PrefixesBuilder do
  describe '#build' do
    it 'returns the prefixes for index' do
      expect(described_class.build(
        origin_prefixes: ['wallaby/resources', 'application'],
        theme_name: 'one_admin',
        resources_name: 'products',
        script_name: '/admin',
        action_name: :index
      )).to eq ["admin/products/index", "admin/products", "one_admin/index", "one_admin", "wallaby/resources/index", "wallaby/resources"]

      expect(described_class.build(
        origin_prefixes: ['admin/application', 'wallaby/resources', 'application'],
        theme_name: 'one_admin',
        resources_name: 'products',
        script_name: '/admin',
        action_name: :index
      )).to eq ["admin/products/index", "admin/products", "admin/application/index", "admin/application", "one_admin/index", "one_admin", "wallaby/resources/index", "wallaby/resources"]

      expect(described_class.build(
        origin_prefixes: ['admin/products', 'admin/application', 'wallaby/resources', 'application'],
        theme_name: 'one_admin',
        resources_name: 'products',
        script_name: '/admin',
        action_name: :index
      )).to eq ["admin/products/index", "admin/products", "admin/application/index", "admin/application", "one_admin/index", "one_admin", "wallaby/resources/index", "wallaby/resources"]

      expect(described_class.build(
        origin_prefixes: ['wallaby/resources', 'application'],
        theme_name: 'one_admin',
        resources_name: 'products',
        script_name: '',
        action_name: :index
      )).to eq ["products/index", "products", "one_admin/index", "one_admin", "wallaby/resources/index", "wallaby/resources"]

      expect(described_class.build(
        origin_prefixes: ['products', 'wallaby/resources', 'application'],
        theme_name: 'one_admin',
        resources_name: 'products',
        script_name: '',
        action_name: :index
      )).to eq ["products/index", "products", "one_admin/index", "one_admin", "wallaby/resources/index", "wallaby/resources"]

      expect(described_class.build(
        origin_prefixes: ['products', 'wallaby/resources', 'application'],
        theme_name: '',
        resources_name: 'products',
        script_name: '',
        action_name: :index
      )).to eq ["products/index", "products", "wallaby/resources/index", "wallaby/resources"]
    end

    it 'returns the prefixes for edit' do
      expect(described_class.build(
        origin_prefixes: ['wallaby/resources', 'application'],
        theme_name: 'one_admin',
        resources_name: 'products',
        script_name: '/admin',
        action_name: :edit
      )).to eq ["admin/products/form", "admin/products", "one_admin/form", "one_admin", "wallaby/resources/form", "wallaby/resources"]

      expect(described_class.build(
        origin_prefixes: ['admin/application', 'wallaby/resources', 'application'],
        theme_name: 'one_admin',
        resources_name: 'products',
        script_name: '/admin',
        action_name: :edit
      )).to eq ["admin/products/form", "admin/products", "admin/application/form", "admin/application", "one_admin/form", "one_admin", "wallaby/resources/form", "wallaby/resources"]

      expect(described_class.build(
        origin_prefixes: ['admin/products', 'admin/application', 'wallaby/resources', 'application'],
        theme_name: 'one_admin',
        resources_name: 'products',
        script_name: '/admin',
        action_name: :edit
      )).to eq ["admin/products/form", "admin/products", "admin/application/form", "admin/application", "one_admin/form", "one_admin", "wallaby/resources/form", "wallaby/resources"]

      expect(described_class.build(
        origin_prefixes: ['wallaby/resources', 'application'],
        theme_name: 'one_admin',
        resources_name: 'products',
        script_name: '',
        action_name: :edit
      )).to eq ["products/form", "products", "one_admin/form", "one_admin", "wallaby/resources/form", "wallaby/resources"]

      expect(described_class.build(
        origin_prefixes: ['products', 'wallaby/resources', 'application'],
        theme_name: 'one_admin',
        resources_name: 'products',
        script_name: '',
        action_name: :edit
      )).to eq ["products/form", "products", "one_admin/form", "one_admin", "wallaby/resources/form", "wallaby/resources"]

      expect(described_class.build(
        origin_prefixes: ['products', 'wallaby/resources', 'application'],
        theme_name: '',
        resources_name: 'products',
        script_name: '',
        action_name: :edit
      )).to eq ["products/form", "products", "wallaby/resources/form", "wallaby/resources"]
    end
  end
end
