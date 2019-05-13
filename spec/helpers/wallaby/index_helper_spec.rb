require 'rails_helper'

describe Wallaby::IndexHelper, :current_user do
  include Wallaby::ApplicationHelper

  describe '#all_label' do
    it 'returns a label' do
      expect(helper.all_label).to eq 'All'
    end
  end

  describe '#json_fields_of' do
    it 'returns a list of field names' do
      expect(helper.json_fields_of([])).to eq []
      expect(helper.json_fields_of([Wallaby::ResourceDecorator.new(Product.new)])).to eq %w(id sku name stock price featured available_to_date available_to_time published_at)
      expect(helper.json_fields_of([Wallaby::ResourceDecorator.new(Product.new)], nil)).to eq %w(id sku name stock price featured available_to_date available_to_time published_at)
      expect(helper.json_fields_of([Wallaby::ResourceDecorator.new(Product.new)], [])).to eq %w(id sku name stock price featured available_to_date available_to_time published_at)
      expect(helper.json_fields_of([Wallaby::ResourceDecorator.new(Product.new)], %w(sku name))).to eq %w(sku name)
      expect(helper.json_fields_of([Wallaby::ResourceDecorator.new(Product.new)], 'sku,name')).to eq %w(sku name)
      expect(helper.json_fields_of([Wallaby::ResourceDecorator.new(Product.new)], %w(sku name unknown))).to eq %w(sku name)
      expect(helper.json_fields_of([Wallaby::ResourceDecorator.new(Product.new)], 'sku,name,unknown')).to eq %w(sku name)
      expect(helper.json_fields_of([Wallaby::ResourceDecorator.new(Product.new)], %w(unknown))).to eq []
      expect(helper.json_fields_of([Wallaby::ResourceDecorator.new(Product.new)], 'unknown')).to eq []
    end
  end

  describe '.filter_link' do
    it 'returns filter name' do
      default_url_options = { script_name: '/admin', resources: 'products', action: 'index' }
      expect(helper.filter_link(Product, :all, url_params: default_url_options)).to eq '<a title="Product" href="/admin/products?filter=all">All</a>'
      expect(helper.filter_link(Product, :all, filters: { filter: { default: true } }, url_params: default_url_options)).to eq '<a title="Product" href="/admin/products?filter=all">All</a>'
      expect(helper.filter_link(Product, :filter, filters: { filter: { default: true } }, url_params: default_url_options)).to eq '<a title="Product" href="/admin/products">Filter</a>'
      expect(helper.filter_link(Product, :filter, filters: { filter: { default: true } }, url_params: default_url_options.merge(date_from: '2018-06-11'))).to eq '<a title="Product" href="/admin/products?date_from=2018-06-11">Filter</a>'
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
      default_url_options = { script_name: '/admin', resources: 'products', action: 'index' }
      expect(helper.export_link(Product, url_params: default_url_options)).to eq '<a title="Product" href="/admin/products.csv">Export as CSV</a>'
      helper.index_params[:page] = 8
      helper.index_params[:per] = 10
      expect(helper.export_link(Product, url_params: default_url_options)).to eq '<a title="Product" href="/admin/products.csv">Export as CSV</a>'
      expect(helper.export_link(Product, url_params: default_url_options.merge(date_from: '2018-06-11'))).to eq '<a title="Product" href="/admin/products.csv?date_from=2018-06-11">Export as CSV</a>'
      expect(helper.export_link(Product, url_params: parameters!(default_url_options.merge(date_from: '2018-06-11')))).to eq '<a title="Product" href="/admin/products.csv?date_from=2018-06-11">Export as CSV</a>'
    end
  end
end
