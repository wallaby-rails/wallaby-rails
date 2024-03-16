# frozen_string_literal: true

require 'rails_helper'

describe Wallaby::Inflector do
  describe '.to_class_name' do
    it 'returns class name' do
      expect(described_class.to_class_name('')).to eq ''

      expect(described_class.to_class_name('admin/categories')).to eq 'Admin::Category'
      expect(described_class.to_class_name('admin::category')).to eq 'Admin::Category'
      expect(described_class.to_class_name('/admin/categories')).to eq '::Admin::Category'
      expect(described_class.to_class_name('/admin::category')).to eq '::Admin::Category'
    end
  end

  describe '.to_script' do
    it 'returns string' do
      expect(described_class.to_script('', 'category')).to eq 'category'
      expect(described_class.to_script('', 'categories')).to eq 'categories'
      expect(described_class.to_script('', 'order::item')).to eq 'order::item'
      expect(described_class.to_script('', 'order::items')).to eq 'order::items'
      expect(described_class.to_script('', 'order::items', 'controller')).to eq 'order::items_controller'
      expect(described_class.to_script('', 'order::items', '_controller')).to eq 'order::items_controller'

      expect(described_class.to_script('/admin', 'categories')).to eq 'admin/categories'
      expect(described_class.to_script('/admin', 'order::items')).to eq 'admin/order::items'
      expect(described_class.to_script('/admin', 'order::items', 'controller')).to eq 'admin/order::items_controller'
      expect(described_class.to_script('/admin', 'order::items', '_controller')).to eq 'admin/order::items_controller'
    end
  end

  describe '.to_resources_name' do
    it 'handles the namespace and returns resources name for a class name' do
      expect(described_class.to_resources_name('Post')).to eq 'posts'
      expect(described_class.to_resources_name('Wallaby::Post')).to eq 'wallaby::posts'
      expect(described_class.to_resources_name('wallaby/posts')).to eq 'wallaby::posts'
      expect(described_class.to_resources_name('Person')).to eq 'people'
      expect(described_class.to_resources_name('Wallaby::Person')).to eq 'wallaby::people'
      expect(described_class.to_resources_name('wallaby/person')).to eq 'wallaby::people'
      expect(described_class.to_resources_name('Wallabies::Person')).to eq 'wallabies::people'
      expect(described_class.to_resources_name('wallabies/person')).to eq 'wallabies::people'
    end

    context 'when model_class is blank' do
      it 'returns blank string' do
        expect(described_class.to_resources_name(nil)).to eq ''
        expect(described_class.to_resources_name('')).to eq ''
        expect(described_class.to_resources_name(' ')).to eq ''

        expect(described_class.to_resources_name(false)).to eq ''
        expect(described_class.to_resources_name([])).to eq ''
        expect(described_class.to_resources_name({})).to eq ''
      end
    end
  end

  describe '.to_controller_name' do
    it 'returns the controller class name' do
      expect(described_class.to_controller_name('/admin', 'categories')).to eq 'Admin::CategoriesController'
      expect(described_class.to_controller_name('/admin', 'category')).to eq 'Admin::CategoriesController'
      expect(described_class.to_controller_name('/admin', 'order::items')).to eq 'Admin::Order::ItemsController'
      expect(described_class.to_controller_name('/admin', 'order::item')).to eq 'Admin::Order::ItemsController'
      expect(described_class.to_controller_name('/admin', 'Order::Item')).to eq 'Admin::Order::ItemsController'
    end
  end

  describe '.to_decorator_name' do
    it 'returns the decorator class name' do
      expect(described_class.to_decorator_name('/admin', 'categories')).to eq 'Admin::CategoryDecorator'
      expect(described_class.to_decorator_name('/admin', 'category')).to eq 'Admin::CategoryDecorator'
      expect(described_class.to_decorator_name('/admin', 'order::items')).to eq 'Admin::Order::ItemDecorator'
      expect(described_class.to_decorator_name('/admin', 'order::item')).to eq 'Admin::Order::ItemDecorator'
      expect(described_class.to_decorator_name('/admin', 'Order::Item')).to eq 'Admin::Order::ItemDecorator'
    end
  end

  describe '.to_authorizer_name' do
    it 'returns the authorizer class name' do
      expect(described_class.to_authorizer_name('/admin', 'categories')).to eq 'Admin::CategoryAuthorizer'
      expect(described_class.to_authorizer_name('/admin', 'category')).to eq 'Admin::CategoryAuthorizer'
      expect(described_class.to_authorizer_name('/admin', 'order::items')).to eq 'Admin::Order::ItemAuthorizer'
      expect(described_class.to_authorizer_name('/admin', 'order::item')).to eq 'Admin::Order::ItemAuthorizer'
    end
  end

  describe '.to_model_label' do
    it 'returns model label for a model class' do
      expect(described_class.to_model_label('posts')).to eq 'Post'
      expect(described_class.to_model_label('wallaby::posts')).to eq 'Wallaby / Post'
      expect(described_class.to_model_label('post')).to eq 'Post'
      expect(described_class.to_model_label('wallaby::post')).to eq 'Wallaby / Post'
      expect(described_class.to_model_label('people')).to eq 'Person'
      expect(described_class.to_model_label('wallaby::people')).to eq 'Wallaby / Person'
      expect(described_class.to_model_label('wallabies::people')).to eq 'Wallabies / Person'

      expect(described_class.to_model_label('person')).to eq 'Person'
      expect(described_class.to_model_label('wallaby::person')).to eq 'Wallaby / Person'
      expect(described_class.to_model_label('wallabies::person')).to eq 'Wallabies / Person'
    end

    context 'when model_class is blank' do
      it 'returns blank string' do
        expect(described_class.to_model_label(nil)).to eq ''
        expect(described_class.to_model_label('')).to eq ''
        expect(described_class.to_model_label(' ')).to eq ''

        expect(described_class.to_model_label(false)).to eq ''
        expect(described_class.to_model_label([])).to eq ''
        expect(described_class.to_model_label({})).to eq ''
      end
    end
  end

  describe '.to_model_name' do
    it 'returns model name for a resources name' do
      expect(described_class.to_model_name('posts')).to eq 'Post'
      expect(described_class.to_model_name('wallaby::posts')).to eq 'Wallaby::Post'
      expect(described_class.to_model_name('post')).to eq 'Post'
      expect(described_class.to_model_name('wallaby::post')).to eq 'Wallaby::Post'
      expect(described_class.to_model_name('people')).to eq 'Person'
      expect(described_class.to_model_name('wallaby::people')).to eq 'Wallaby::Person'
      expect(described_class.to_model_name('wallabies::people')).to eq 'Wallabies::Person'
    end

    context 'when resources_name is blank' do
      it 'returns blank string' do
        expect(described_class.to_model_name(nil)).to eq ''
        expect(described_class.to_model_name('')).to eq ''
        expect(described_class.to_model_name(' ')).to eq ''

        expect(described_class.to_model_name(false)).to eq ''
        expect(described_class.to_model_name([])).to eq ''
        expect(described_class.to_model_name({})).to eq ''
      end
    end
  end
end
