require 'rails_helper'

describe Wallaby::LinksHelper, :current_user do
  extend Wallaby::ApplicationHelper

  describe '#index_params' do
    it 'permits the following keywords' do
      hash = { 'q' => 'keywords', 'page' => 2, 'per' => 20, 'sort' => 'name asc' }
      hash.each { |key, value| helper.params[key] = value }
      expect(helper.index_params.to_h).to eq hash
      helper.params[:something] = 'else'
      expect(helper.index_params.to_h).to eq hash
    end
  end

  describe '#index_path' do
    it 'returns index path' do
      expect(helper.index_path(Product)).to eq '/admin/products'
      expect(helper.index_path(Product, parameters(sort: 'name asc'))).to eq '/admin/products'
    end

    context 'when extra params are given' do
      it 'returns index path with queries' do
        expect(helper.index_path(Product, parameters(sort: 'name asc').permit!)).to eq '/admin/products?sort=name+asc'
      end
    end
  end

  describe '#new_path' do
    it 'returns new path' do
      expect(helper.new_path(Product)).to eq '/admin/products/new'
    end
  end

  describe '#show_path' do
    it 'returns show path' do
      expect(helper.show_path(Product.new(id: 1))).to eq '/admin/products/1'
    end
  end

  describe '#edit_path' do
    it 'returns edit path' do
      expect(helper.edit_path(Product.new(id: 1))).to eq '/admin/products/1/edit'
    end
  end

  describe '#index_link' do
    it 'returns index link' do
      expect(helper.index_link(Product)).to eq '<a href="/admin/products">Product</a>'
      expect(helper.index_link(Product) { 'List' }).to eq '<a href="/admin/products">List</a>'
      expect(helper.index_link(Product, extra_params: parameters(sort: 'name asc').permit!) { 'List' }).to eq '<a href="/admin/products?sort=name+asc">List</a>'
    end

    context 'when cannot index' do
      it 'returns nil' do
        ability = helper.current_ability
        ability.cannot :index, Product
        expect(helper.index_link(Product)).to be_nil
      end
    end
  end

  describe '#new_link' do
    it 'returns new link' do
      expect(helper.new_link(Product)).to eq '<a class="text-success" href="/admin/products/new">Create Product</a>'
      expect(helper.new_link(Product) { 'New' }).to eq '<a class="text-success" href="/admin/products/new">New</a>'
      expect(helper.new_link(Product, class: 'test')).to eq '<a class="test" href="/admin/products/new">Create Product</a>'
      expect(helper.new_link(Product, class: 'test', prepend: 'Or')).to eq 'Or <a class="test" href="/admin/products/new">Create Product</a>'
    end

    context 'when cannot new' do
      it 'returns nil' do
        ability = helper.current_ability
        ability.cannot :new, Product
        expect(helper.new_link(Product)).to be_nil
      end
    end
  end

  describe '#show_link' do
    let(:resource) { Product.new id: 1 }

    it 'returns show link' do
      expect(helper.show_link(resource)).to eq '<a href="/admin/products/1">1</a>'
      expect(helper.show_link(resource) { 'Show' }).to eq '<a href="/admin/products/1">Show</a>'
    end

    context 'when cannot show' do
      it 'returns nil' do
        ability = helper.current_ability
        ability.cannot :show, Product
        expect(helper.show_link(resource)).to be_nil
      end

      context 'when resource is decorated' do
        let(:resource) { helper.decorate Product.new id: 1 }

        it 'returns nil' do
          ability = helper.current_ability
          ability.cannot :show, Product
          expect(helper.show_link(resource)).to be_nil
        end
      end
    end
  end

  describe '#edit_link' do
    let(:resource) { Product.new id: 1 }

    it 'returns edit link' do
      expect(helper.edit_link(resource)).to eq '<a class="text-warning" href="/admin/products/1/edit">Edit 1</a>'
      expect(helper.edit_link(resource) { 'Edit' }).to eq '<a class="text-warning" href="/admin/products/1/edit">Edit</a>'
      expect(helper.edit_link(resource, class: 'test')).to eq '<a class="test" href="/admin/products/1/edit">Edit 1</a>'
    end

    context 'when cannot edit' do
      it 'returns nil' do
        ability = helper.current_ability
        ability.cannot :edit, Product
        expect(helper.edit_link(resource)).to be_nil
      end

      context 'when resource is decorated' do
        let(:resource) { helper.decorate Product.new id: 1 }

        it 'returns nil' do
          ability = helper.current_ability
          ability.cannot :edit, Product
          expect(helper.edit_link(resource)).to be_nil
        end
      end
    end
  end

  describe '#delete_link' do
    let(:resource) { Product.new id: 1 }

    it 'returns delete link' do
      expect(helper.delete_link(resource)).to eq '<a class="text-danger" data-confirm="Please confirm to delete" rel="nofollow" data-method="delete" href="/admin/products/1">Delete</a>'
      expect(helper.delete_link(resource) { 'Destroy' }).to eq '<a class="text-danger" data-confirm="Please confirm to delete" rel="nofollow" data-method="delete" href="/admin/products/1">Destroy</a>'
      expect(helper.delete_link(resource, class: 'test')).to eq '<a class="test" data-confirm="Please confirm to delete" rel="nofollow" data-method="delete" href="/admin/products/1">Delete</a>'
      expect(helper.delete_link(resource, method: :put)).to eq '<a class="text-danger" data-confirm="Please confirm to delete" rel="nofollow" data-method="put" href="/admin/products/1">Delete</a>'
      expect(helper.delete_link(resource, data: { confirm: 'Delete now!' })).to eq '<a data-confirm="Delete now!" class="text-danger" rel="nofollow" data-method="delete" href="/admin/products/1">Delete</a>'
    end

    context 'when cannot delete' do
      it 'returns nil' do
        ability = helper.current_ability
        ability.cannot :destroy, Product
        expect(helper.delete_link(resource)).to be_nil
      end

      context 'when resource is decorated' do
        let(:resource) { helper.decorate Product.new id: 1 }

        it 'returns nil' do
          ability = helper.current_ability
          ability.cannot :destroy, Product
          expect(helper.delete_link(resource)).to be_nil
        end
      end
    end
  end

  describe '#cancel_link' do
    it 'returns cancel link' do
      expect(helper.cancel_link).to eq '<a href="javascript:history.back()">Cancel</a>'
      expect(helper.cancel_link { 'Back' }).to eq '<a href="javascript:history.back()">Back</a>'
    end
  end

  describe '#prepend_if' do
    it 'returns the prepended text' do
      expect(helper.prepend_if).to eq ''

      html_options = { prepend: 'Or' }
      expect(helper.prepend_if(html_options)).to eq 'Or '
      expect(html_options).not_to have_key :prepend
    end
  end
end
