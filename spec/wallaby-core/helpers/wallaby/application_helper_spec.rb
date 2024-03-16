# frozen_string_literal: true

require 'rails_helper'

describe Wallaby::ApplicationHelper, :wallaby_user, type: :helper do
  describe 'url related' do
    let(:url_options) { nil }
    let(:controller_path) { nil }
    let(:model_class) { nil }

    before do
      allow(helper).to receive(:url_options).and_return(url_options) if url_options.present?
      allow(helper).to receive(:controller_path).and_return(controller_path) if controller_path.present?
      allow(helper).to receive(:current_model_class).and_return(model_class) if model_class.present?
    end

    context 'when /admin', script_name: '/admin' do
      context 'when it is under /admin home' do
        let(:url_options) do
          { host: "localhost", port: 5000, protocol: "http://", _recall: { action: "home" }, script_name: "" }
        end

        let(:controller_path) { 'admin/application' }

        context 'when options is hash or permitted parameters' do
          it 'generates URL for hash' do
            expect(helper.url_for(action: 'home')).to eq '/admin/'

            Wallaby::ERRORS.each do |error|
              expect(helper.url_for(action: error)).to eq "/admin/#{error}"
            end

            expect(helper.url_for(resources: 'products', action: 'index')).to eq '/admin/products'
            expect(helper.url_for(resources: 'products', action: 'new')).to eq '/admin/products/new'
            expect(helper.url_for(resources: 'products', action: 'show', id: 1)).to eq '/admin/products/1'
            expect(helper.url_for(resources: 'products', action: 'edit', id: 1)).to eq '/admin/products/1/edit'

            expect(helper.url_for(resources: 'categories', action: 'index')).to eq '/admin/categories'
            expect(helper.url_for(resources: 'categories', action: 'new')).to eq '/admin/categories/new'
            expect(helper.url_for(resources: 'categories', action: 'show', id: 1)).to eq '/admin/categories/1'
            expect(helper.url_for(resources: 'categories', action: 'edit', id: 1)).to eq '/admin/categories/1/edit'

            expect(helper.index_path(Product)).to eq '/admin/products'
            expect(helper.index_path(Category)).to eq '/admin/categories'
          end

          it 'generates URL for permitted parameters' do
            expect(helper.url_for(parameters!(action: 'home'))).to eq '/admin/'

            Wallaby::ERRORS.each do |error|
              expect(helper.url_for(parameters!(action: error))).to eq "/admin/#{error}"
            end

            expect(helper.url_for(parameters!(resources: 'products', action: 'index'))).to eq '/admin/products'
            expect(helper.url_for(parameters!(resources: 'products', action: 'new'))).to eq '/admin/products/new'
            expect(helper.url_for(parameters!(resources: 'products', action: 'show', id: 1))).to eq '/admin/products/1'
            expect(helper.url_for(parameters!(resources: 'products', action: 'edit', id: 1))).to eq '/admin/products/1/edit'

            expect(helper.url_for(parameters!(resources: 'categories', action: 'index'))).to eq '/admin/categories'
            expect(helper.url_for(parameters!(resources: 'categories', action: 'new'))).to eq '/admin/categories/new'
            expect(helper.url_for(parameters!(resources: 'categories', action: 'show', id: 1))).to eq '/admin/categories/1'
            expect(helper.url_for(parameters!(resources: 'categories', action: 'edit', id: 1))).to eq '/admin/categories/1/edit'
          end

          it 'generates URL for before engine', script_name: '/before_engine' do
            expect(helper.url_for(action: 'home')).to eq '/before_engine/'

            Wallaby::ERRORS.each do |error|
              expect(helper.url_for(action: error)).to eq "/before_engine/#{error}"
            end

            expect(helper.url_for(resources: 'products', action: 'index')).to eq '/before_engine/products'
            expect(helper.url_for(resources: 'products', action: 'new')).to eq '/before_engine/products/new'
            expect(helper.url_for(resources: 'products', action: 'show', id: 1)).to eq '/before_engine/products/1'
            expect(helper.url_for(resources: 'products', action: 'edit', id: 1)).to eq '/before_engine/products/1/edit'

            expect(helper.url_for(resources: 'categories', action: 'index')).to eq '/before_engine/categories'
            expect(helper.url_for(resources: 'categories', action: 'new')).to eq '/before_engine/categories/new'
            expect(helper.url_for(resources: 'categories', action: 'show', id: 1)).to eq '/before_engine/categories/1'
            expect(helper.url_for(resources: 'categories', action: 'edit', id: 1)).to eq '/before_engine/categories/1/edit'

            expect(helper.index_path(Product)).to eq '/before_engine/products'
            expect(helper.index_path(Category)).to eq '/before_engine/categories'
          end
        end

        context 'when options is neither hash or permitted parameters' do
          it 'generates URL for strings' do
            expect(helper.url_for('')).to eq ''
            expect(helper.url_for('/products')).to eq '/products'
          end

          it 'generates URL for array' do
            expect(helper.url_for([:products])).to eq '/products'
            expect(helper.url_for(%i[profile postcodes])).to eq '/profile/postcodes'
            expect(helper.url_for(%i[before products])).to eq '/before/products'
            expect { helper.url_for(%i[admin products]) }.to raise_error NoMethodError
          end

          it 'raises error for unpermitted params' do
            expect { helper.url_for(parameters(action: 'home')) }.to raise_error ActionController::UnfilteredParameters
          end
        end
      end

      context 'when it is under /admin/products' do
        let(:url_options) do
          { host: "localhost", port: 5000, protocol: "http://", _recall: { action: "index", resources: "products" }, script_name: "" }
        end

        let(:controller_path) { 'admin/application' }
        let(:model_class) { Product }

        it 'generates URL' do
          expect(helper.url_for(action: 'home')).to eq '/admin/'

          Wallaby::ERRORS.each do |error|
            expect(helper.url_for(action: error)).to eq "/admin/#{error}"
          end

          expect(helper.url_for(action: 'index')).to eq '/admin/products'
          expect(helper.url_for(action: 'new')).to eq '/admin/products/new'
          expect(helper.url_for(action: 'show', id: 1)).to eq '/admin/products/1'
          expect(helper.url_for(action: 'edit', id: 1)).to eq '/admin/products/1/edit'

          expect(helper.url_for(resources: 'categories', action: 'index')).to eq '/admin/categories'
          expect(helper.url_for(resources: 'categories', action: 'new')).to eq '/admin/categories/new'
          expect(helper.url_for(resources: 'categories', action: 'show', id: 1)).to eq '/admin/categories/1'
          expect(helper.url_for(resources: 'categories', action: 'edit', id: 1)).to eq '/admin/categories/1/edit'

          expect(helper.index_path(Product)).to eq '/admin/products'
          expect(helper.index_path(Category)).to eq '/admin/categories'
        end
      end

      context 'when it is under overriden /admin/categories' do
        let(:url_options) do
          { host: "localhost", port: 5000, protocol: "http://", _recall: { action: "index" }, script_name: "" }
        end

        let(:controller_path) { 'admin/categories' }
        let(:model_class) { Category }

        it 'generates URL' do
          expect(helper.url_for(action: 'home')).to eq '/admin/'

          Wallaby::ERRORS.each do |error|
            expect(helper.url_for(action: error)).to eq "/admin/#{error}"
          end

          expect(helper.url_for(action: 'index')).to eq '/admin/categories'
          expect(helper.url_for(action: 'new')).to eq '/admin/categories/new'
          expect(helper.url_for(action: 'show', id: 1)).to eq '/admin/categories/1'
          expect(helper.url_for(action: 'edit', id: 1)).to eq '/admin/categories/1/edit'

          expect(helper.url_for(resources: 'products', action: 'index')).to eq '/admin/products'
          expect(helper.url_for(resources: 'products', action: 'new')).to eq '/admin/products/new'
          expect(helper.url_for(resources: 'products', action: 'show', id: 1)).to eq '/admin/products/1'
          expect(helper.url_for(resources: 'products', action: 'edit', id: 1)).to eq '/admin/products/1/edit'

          expect(helper.url_for(resources: 'categories', action: 'index')).to eq '/admin/categories'
          expect(helper.url_for(resources: 'categories', action: 'new')).to eq '/admin/categories/new'
          expect(helper.url_for(resources: 'categories', action: 'show', id: 1)).to eq '/admin/categories/1'
          expect(helper.url_for(resources: 'categories', action: 'edit', id: 1)).to eq '/admin/categories/1/edit'

          expect(helper.index_path(Product)).to eq '/admin/products'
          expect(helper.index_path(Category)).to eq '/admin/categories'
        end
      end

      context 'when it is under overriden /admin/custom_categories' do
        let(:url_options) do
          { host: "localhost", port: 5000, protocol: "http://", _recall: { action: "index" }, script_name: "" }
        end

        let(:controller_path) { 'admin/custom_categories' }
        let(:model_class) { Category }

        it 'generates URL' do
          expect(helper.url_for(action: 'home')).to eq '/admin/'

          Wallaby::ERRORS.each do |error|
            expect(helper.url_for(action: error)).to eq "/admin/#{error}"
          end

          expect(helper.url_for(action: 'index')).to eq '/admin/custom_categories'
          expect(helper.url_for(action: 'new')).to eq '/admin/custom_categories/new'
          expect(helper.url_for(action: 'show', id: 1)).to eq '/admin/custom_categories/1'
          expect(helper.url_for(action: 'edit', id: 1)).to eq '/admin/custom_categories/1/edit'

          expect(helper.url_for(resources: 'products', action: 'index')).to eq '/admin/products'
          expect(helper.url_for(resources: 'products', action: 'new')).to eq '/admin/products/new'
          expect(helper.url_for(resources: 'products', action: 'show', id: 1)).to eq '/admin/products/1'
          expect(helper.url_for(resources: 'products', action: 'edit', id: 1)).to eq '/admin/products/1/edit'

          expect(helper.url_for(resources: 'categories', action: 'index')).to eq '/admin/custom_categories'
          expect(helper.url_for(resources: 'categories', action: 'new')).to eq '/admin/custom_categories/new'
          expect(helper.url_for(resources: 'categories', action: 'show', id: 1)).to eq '/admin/custom_categories/1'
          expect(helper.url_for(resources: 'categories', action: 'edit', id: 1)).to eq '/admin/custom_categories/1/edit'

          expect(helper.index_path(Product)).to eq '/admin/products'
          expect(helper.index_path(Category)).to eq '/admin/custom_categories'
        end
      end
    end
  end

  describe '#form_for' do
    it 'uses the Wallaby::FormBuilder' do
      product = Product.new
      product.errors.add :name, 'invalid name'
      expect(helper.form_for(product) do |f|
        f.error_messages :name
      end).to include 'invalid name'
    end
  end
end
