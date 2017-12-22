require 'rails_helper'

describe Wallaby::IndexHelper, :current_user do
  include Wallaby::ApplicationHelper

  describe '#paginate' do
    it 'returns a paginator' do
      expect(helper.paginate(Product, [], {})).to be_kind_of Wallaby::ResourcePaginator
    end
  end

  describe '#all_label' do
    it 'returns a label' do
      expect(helper.all_label).to eq 'All'
    end
  end

  describe '#filter_label' do
    it 'returns a label for filter' do
      expect(helper.filter_label(:all, {})).to eq 'All'
      expect(helper.filter_label(:all, all: { label: 'All records' })).to eq 'All records'
    end
  end

  describe '.export_link' do
    it 'returns filter name' do
      expect(helper.export_link(Product)).to eq '<a href="/admin/products.csv">Export as CSV</a>'
      helper.index_params[:page] = 8
      helper.index_params[:per] = 10
      expect(helper.export_link(Product)).to eq '<a href="/admin/products.csv">Export as CSV</a>'
    end
  end

  describe '.filter_link' do
    it 'returns filter name' do
      expect(helper.filter_link(Product, :all, {})).to eq '<a href="/admin/products?filter=all">All</a>'
      expect(helper.filter_link(Product, :all, filter: { default: true })).to eq '<a href="/admin/products?filter=all">All</a>'
      expect(helper.filter_link(Product, :filter, filter: { default: true })).to eq '<a href="/admin/products">Filter</a>'
    end
  end
end
