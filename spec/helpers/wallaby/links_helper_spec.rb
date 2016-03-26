require 'rails_helper'

describe Wallaby::LinksHelper do
  extend Wallaby::ApplicationHelper

  describe '#index_path' do
    it 'returns index path' do
      expect(helper.index_path Product).to match '/products'
    end
  end

  describe '#new_path' do
    it 'returns new path' do
      expect(helper.new_path Product).to match '/products/new'
    end
  end

  describe '#show_path' do
    it 'returns show path' do
      expect(helper.show_path Product.new id: 1).to match '/products/1'
    end
  end

  describe '#edit_path' do
    it 'returns edit path' do
      expect(helper.edit_path Product.new id: 1).to match '/products/1/edit'
    end
  end

  describe '#index_link' do
    it 'returns index link' do
      expect(helper.index_link(Product)).to eq "<a href=\"/admin/products\">Product</a>"
      expect(helper.index_link(Product) { 'List' }).to eq "<a href=\"/admin/products\">List</a>"
    end
  end

  describe '#new_link' do
    it 'returns new link' do
      expect(helper.new_link Product).to eq "<a class=\"text-success\" href=\"/admin/products/new\">Create Product</a>"
      expect(helper.new_link(Product) { 'New' }).to eq "<a class=\"text-success\" href=\"/admin/products/new\">New</a>"
    end
  end

  describe '#show_link' do
    it 'returns show link' do
      expect(helper.show_link(Product.new id: 1)).to eq "<a href=\"/admin/products/1\">1</a>"
      expect(helper.show_link(Product.new id: 1) { 'Show' }).to eq "<a href=\"/admin/products/1\">Show</a>"
    end
  end

  describe '#edit_link' do
    it 'returns edit link' do
      expect(helper.edit_link(Product.new id: 1)).to eq "<a class=\"text-warning\" href=\"/admin/products/1/edit\">Edit 1</a>"
      expect(helper.edit_link(Product.new id: 1) { 'Edit' }).to eq "<a class=\"text-warning\" href=\"/admin/products/1/edit\">Edit</a>"
    end
  end

  describe '#delete_link' do
    it 'returns delete link' do
      expect(helper.delete_link(Product.new id: 1) { 'Delete' }).to eq "<a data-confirm=\"Please confirm to delete\" rel=\"nofollow\" data-method=\"delete\" href=\"/admin/products/1\">Delete</a>"
    end
  end

  describe '#cancel_link' do
    it 'returns cancel link' do
      expect(helper.cancel_link).to eq "<a href=\"javascript:history.back()\">Cancel</a>"
    end
  end

  describe '#prepend_if' do
    it 'returns the prepended text' do
      expect(helper.prepend_if).to be_nil
      expect(helper).to receive(:concat).with('Or ') { 'Or ' }
      expect(helper.prepend_if prepend: 'Or').to eq 'Or '
    end
  end
end
