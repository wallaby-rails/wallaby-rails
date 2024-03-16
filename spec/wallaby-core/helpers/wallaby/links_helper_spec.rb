# frozen_string_literal: true

require 'rails_helper'

describe Wallaby::LinksHelper, :wallaby_user, type: :helper do
  extend Wallaby::ApplicationHelper

  describe '#index_path' do
    it 'returns index path' do
      expect(helper.index_path(Product)).to eq '/admin/products'
    end

    context 'when script name is blank' do
      it 'returns index path', script_name: '' do
        helper.url_options[:_recall] = { controller: 'products' }
        expect(helper.index_path(Product)).to eq '/products'
      end

      context 'when defined by resource' do
        it 'returns index path', script_name: '' do
          helper.url_options[:_recall] = { controller: 'blogs' }
          expect(helper.index_path(Blog)).to eq '/blogs'
        end
      end
    end

    it 'accepts url_params' do
      expect(helper.index_path(Product, url_params: { sort: 'name asc' })).to eq '/admin/products?sort=name+asc'
      expect(helper.index_path(Product, url_params: parameters!(sort: 'name asc'))).to eq '/admin/products?sort=name+asc'
    end
  end

  describe '#new_path' do
    it 'returns new path' do
      expect(helper.new_path(Product)).to eq '/admin/products/new'
    end

    context 'when script name is blank' do
      it 'returns new path', script_name: '' do
        helper.url_options[:_recall] = { controller: 'products' }
        expect(helper.new_path(Product)).to eq '/products/new'
      end
    end

    it 'accepts url_params' do
      expect(helper.new_path(Product, url_params: { sort: 'name asc' })).to eq '/admin/products/new?sort=name+asc'
      expect(helper.new_path(Product, url_params: parameters!(sort: 'name asc'))).to eq '/admin/products/new?sort=name+asc'
    end
  end

  describe '#show_path' do
    let(:product) { Product.new id: 1 }

    it 'returns show path' do
      expect(helper.show_path(product)).to eq '/admin/products/1'
    end

    context 'when script name is blank' do
      it 'returns show path', script_name: '' do
        helper.url_options[:_recall] = { controller: 'products' }
        expect(helper.show_path(product)).to eq '/products/1'
      end
    end

    it 'accepts url_params' do
      expect(helper.show_path(product, url_params: { sort: 'name asc' })).to eq '/admin/products/1?sort=name+asc'
      expect(helper.show_path(product, url_params: parameters!(sort: 'name asc'))).to eq '/admin/products/1?sort=name+asc'
    end
  end

  describe '#edit_path' do
    let(:product) { Product.new id: 1 }

    it 'returns edit path' do
      expect(helper.edit_path(product)).to eq '/admin/products/1/edit'
    end

    context 'when script name is blank' do
      it 'returns edit path', script_name: '' do
        helper.url_options[:_recall] = { controller: 'products' }
        expect(helper.edit_path(product)).to eq '/products/1/edit'
      end
    end

    it 'accepts url_params' do
      expect(helper.edit_path(product, url_params: { sort: 'name asc' })).to eq '/admin/products/1/edit?sort=name+asc'
      expect(helper.edit_path(product, url_params: parameters!(sort: 'name asc'))).to eq '/admin/products/1/edit?sort=name+asc'
    end
  end

  describe '#index_link' do
    it 'returns index link' do
      expect(helper.index_link(Product)).to eq '<a title="Product" href="/admin/products">Product</a>'
    end

    it 'accepts options' do
      expect(helper.index_link(Product, options: { url: '/before/products' }, url_params: { sort: 'name asc' }) { 'List' }).to eq '<a title="Product" href="/before/products">List</a>'
    end

    it 'accepts url_params' do
      expect(helper.index_link(Product, url_params: { sort: 'name asc' }) { 'List' }).to eq '<a title="Product" href="/admin/products?sort=name+asc">List</a>'
    end

    it 'accepts html_options' do
      expect(helper.index_link(Product, html_options: { title: 'List' })).to eq '<a title="List" href="/admin/products">Product</a>'
    end

    it 'accepts block' do
      expect(helper.index_link(Product) { 'List' }).to eq '<a title="Product" href="/admin/products">List</a>'
    end

    context 'when cannot index' do
      it 'returns nil' do
        stub_const('Ability', Class.new do
          include ::CanCan::Ability
          def initialize(_user)
            cannot :index, Product
          end
        end)
        expect(helper.index_link(Product)).to be_nil
      end
    end
  end

  describe '#new_link' do
    it 'returns new link' do
      expect(helper.new_link(Product)).to eq '<a title="Create Product" class="resource__create" href="/admin/products/new">Create Product</a>'
    end

    it 'accepts options' do
      expect(helper.new_link(Product, options: { url: '/before/products/new' }, url_params: { sort: 'name asc' })).to eq '<a title="Create Product" class="resource__create" href="/before/products/new">Create Product</a>'
    end

    it 'accepts url_params' do
      expect(helper.new_link(Product, url_params: { sort: 'name asc' })).to eq '<a title="Create Product" class="resource__create" href="/admin/products/new?sort=name+asc">Create Product</a>'
    end

    it 'accepts html_options' do
      expect(helper.new_link(Product, html_options: { class: 'test' })).to eq '<a class="test" title="Create Product" href="/admin/products/new">Create Product</a>'
      expect(helper.new_link(Product, html_options: { title: 'Custom Create' })).to eq '<a title="Custom Create" class="resource__create" href="/admin/products/new">Create Product</a>'
    end

    it 'accepts block' do
      expect(helper.new_link(Product) { 'New' }).to eq '<a title="Create Product" class="resource__create" href="/admin/products/new">New</a>'
    end

    context 'when cannot new' do
      it 'returns nil' do
        stub_const('Ability', Class.new do
          include ::CanCan::Ability
          def initialize(_user)
            cannot :new, Product
          end
        end)
        expect(helper.new_link(Product)).to be_nil
      end
    end

    context 'when readonly' do
      it 'returns nil' do
        stub_const('Admin::ProductDecorator', Class.new(Wallaby::ResourceDecorator) do
          self.readonly = true
        end)

        expect(helper.new_link(Product)).to be_nil
      end
    end
  end

  describe '#show_link' do
    let(:resource) { Product.new id: 1, name: 'iPhone' }

    it 'returns show link' do
      expect(helper.show_link(resource)).to eq '<a title="iPhone" href="/admin/products/1">iPhone</a>'
    end

    it 'accepts options' do
      expect(helper.show_link(resource, options: { url: '/before/products/1' }, url_params: { sort: 'name asc' })).to eq '<a title="iPhone" href="/before/products/1">iPhone</a>'
    end

    context 'when script name is blank' do
      it 'accepts options for singular resource', script_name: '' do
        helper.url_options[:_recall] = { controller: 'profiles' }
        Wallaby.configuration.custom_models = ['Profile']
        expect(helper.show_link(Profile.new(first_name: 'Tian', last: 'Chen', email: 'tian@example.com'), url_params: { sort: 'name asc' })).to eq '<a title="Tian" href="/profile?sort=name+asc">Tian</a>'
      end
    end

    it 'accepts url_params' do
      expect(helper.show_link(resource, url_params: { sort: 'name asc' })).to eq '<a title="iPhone" href="/admin/products/1?sort=name+asc">iPhone</a>'
    end

    it 'accepts html_options' do
      expect(helper.show_link(resource, html_options: { title: 'Show link' }) { 'Show' }).to eq '<a title="Show link" href="/admin/products/1">Show</a>'
    end

    it 'accepts block' do
      expect(helper.show_link(resource) { 'Show' }).to eq '<a title="iPhone" href="/admin/products/1">Show</a>'
    end

    context 'when cannot show' do
      it 'returns readonly label' do
        stub_const('Ability', Class.new do
          include ::CanCan::Ability
          def initialize(_user)
            cannot :show, Product
          end
        end)
        expect(helper.show_link(resource)).to be_nil
        expect(helper.show_link(resource, options: { readonly: true })).to eq 'iPhone'
      end

      context 'when resource is decorated' do
        let(:resource) { helper.decorate Product.new id: 1 }

        it 'returns nil' do
          stub_const('Ability', Class.new do
            include ::CanCan::Ability
            def initialize(_user)
              cannot :show, Product
            end
          end)
          expect(helper.show_link(resource)).to be_nil
        end
      end
    end
  end

  describe '#edit_link' do
    let(:resource) { Product.new id: 1, name: 'iPhone' }

    it 'returns edit link' do
      expect(helper.edit_link(resource)).to eq '<a title="Edit iPhone" class="resource__update" href="/admin/products/1/edit">Edit iPhone</a>'
    end

    it 'accepts options' do
      expect(helper.edit_link(resource, options: { url: '/before/products/1' }, url_params: { sort: 'name asc' })).to eq '<a title="Edit iPhone" class="resource__update" href="/before/products/1">Edit iPhone</a>'
    end

    context 'when script name is blank' do
      it 'accepts options for singular resource', script_name: '' do
        helper.url_options[:_recall] = { controller: 'profiles' }
        Wallaby.configuration.custom_models = ['Profile']
        expect(helper.edit_link(Profile.new(first_name: 'Tian', last: 'Chen', email: 'tian@example.com'), url_params: { sort: 'name asc' })).to eq '<a title="Edit Tian" class="resource__update" href="/profile/edit?sort=name+asc">Edit Tian</a>'
      end
    end

    it 'accepts url_params' do
      expect(helper.edit_link(resource, url_params: { sort: 'name asc' })).to eq '<a title="Edit iPhone" class="resource__update" href="/admin/products/1/edit?sort=name+asc">Edit iPhone</a>'
    end

    it 'accepts html_options' do
      expect(helper.edit_link(resource, html_options: { class: 'test' })).to eq '<a class="test" title="Edit iPhone" href="/admin/products/1/edit">Edit iPhone</a>'
      expect(helper.edit_link(resource, html_options: { title: 'Edit a Product' })).to eq '<a title="Edit a Product" class="resource__update" href="/admin/products/1/edit">Edit iPhone</a>'
    end

    it 'accepts block' do
      expect(helper.edit_link(resource) { 'Edit' }).to eq '<a title="Edit iPhone" class="resource__update" href="/admin/products/1/edit">Edit</a>'
    end

    context 'when cannot edit' do
      it 'returns readonly label' do
        stub_const('Ability', Class.new do
          include ::CanCan::Ability
          def initialize(_user)
            cannot :edit, Product
          end
        end)
        expect(helper.edit_link(resource)).to be_nil
        expect(helper.edit_link(resource, options: { readonly: true })).to eq 'Edit iPhone'
      end

      context 'when resource is decorated' do
        let(:resource) { helper.decorate Product.new id: 1 }

        it 'returns nil' do
          stub_const('Ability', Class.new do
            include ::CanCan::Ability
            def initialize(_user)
              cannot :edit, Product
            end
          end)
          expect(helper.edit_link(resource)).to be_nil
        end
      end
    end

    context 'when readonly' do
      it 'returns nil' do
        stub_const('Admin::ProductDecorator', Class.new(Wallaby::ResourceDecorator) do
          self.readonly = true
        end)

        expect(helper.edit_link(Admin::ProductDecorator.new(resource))).to be_nil
        expect(helper.edit_link(resource)).to eq("<a title=\"Edit iPhone\" class=\"resource__update\" href=\"/admin/products/1/edit\">Edit iPhone</a>")
      end
    end
  end

  describe '#delete_link' do
    let(:resource) { Product.new id: 1 }

    it 'returns delete link' do
      expect(helper.delete_link(resource)).to eq '<a title="Delete" class="resource__destroy" data-confirm="Please confirm to delete" rel="nofollow" data-method="delete" href="/admin/products/1">Delete</a>'
    end

    it 'accepts options' do
      expect(helper.delete_link(resource, options: { url: '/before/products/1' }, url_params: { sort: 'name asc' })).to eq '<a title="Delete" class="resource__destroy" data-confirm="Please confirm to delete" rel="nofollow" data-method="delete" href="/before/products/1">Delete</a>'
    end

    context 'when script name is blank' do
      it 'accepts options for singular resource', script_name: '' do
        helper.url_options[:_recall] = { controller: 'profiles' }
        Wallaby.configuration.custom_models = ['Profile']
        expect(helper.delete_link(Profile.new(first_name: 'Tian', last: 'Chen', email: 'tian@example.com'), url_params: { sort: 'name asc' })).to eq '<a title="Delete" class="resource__destroy" data-confirm="Please confirm to delete" rel="nofollow" data-method="delete" href="/profile?sort=name+asc">Delete</a>'
      end
    end

    it 'accepts url_params' do
      expect(helper.delete_link(resource, url_params: { sort: 'name asc' })).to eq '<a title="Delete" class="resource__destroy" data-confirm="Please confirm to delete" rel="nofollow" data-method="delete" href="/admin/products/1?sort=name+asc">Delete</a>'
    end

    it 'accepts html_options' do
      expect(helper.delete_link(resource, html_options: { class: 'test' })).to eq '<a class="test" title="Delete" data-confirm="Please confirm to delete" rel="nofollow" data-method="delete" href="/admin/products/1">Delete</a>'
      expect(helper.delete_link(resource, html_options: { title: 'Confirm to delete' })).to eq '<a title="Confirm to delete" class="resource__destroy" data-confirm="Please confirm to delete" rel="nofollow" data-method="delete" href="/admin/products/1">Delete</a>'
      expect(helper.delete_link(resource, html_options: { method: :put })).to eq '<a title="Delete" class="resource__destroy" data-confirm="Please confirm to delete" rel="nofollow" data-method="put" href="/admin/products/1">Delete</a>'
      expect(helper.delete_link(resource, html_options: { data: { confirm: 'Delete now!' } })).to eq '<a data-confirm="Delete now!" title="Delete" class="resource__destroy" rel="nofollow" data-method="delete" href="/admin/products/1">Delete</a>'
    end

    it 'accepts block' do
      expect(helper.delete_link(resource) { 'Destroy' }).to eq '<a title="Delete" class="resource__destroy" data-confirm="Please confirm to delete" rel="nofollow" data-method="delete" href="/admin/products/1">Destroy</a>'
    end

    context 'when cannot delete' do
      it 'returns nil' do
        stub_const('Ability', Class.new do
          include ::CanCan::Ability
          def initialize(_user)
            cannot :destroy, Product
          end
        end)
        expect(helper.delete_link(resource)).to be_nil
      end

      context 'when resource is decorated' do
        let(:resource) { helper.decorate Product.new id: 1 }

        it 'returns nil' do
          stub_const('Ability', Class.new do
            include ::CanCan::Ability
            def initialize(_user)
              cannot :destroy, Product
            end
          end)
          expect(helper.delete_link(resource)).to be_nil
        end
      end
    end

    context 'when readonly' do
      it 'returns nil' do
        stub_const('Admin::ProductDecorator', Class.new(Wallaby::ResourceDecorator) do
          self.readonly = true
        end)

        expect(helper.delete_link(Admin::ProductDecorator.new(resource))).to be_nil
        expect(helper.delete_link(resource)).to eq("<a title=\"Delete\" class=\"resource__destroy\" data-confirm=\"Please confirm to delete\" rel=\"nofollow\" data-method=\"delete\" href=\"/admin/products/1\">Delete</a>")
      end
    end
  end

  describe '#cancel_link' do
    it 'returns cancel link' do
      expect(helper.cancel_link).to eq '<a href="javascript:history.back()">Cancel</a>'
      expect(helper.cancel_link { 'Back' }).to eq '<a href="javascript:history.back()">Back</a>'
    end
  end
end
