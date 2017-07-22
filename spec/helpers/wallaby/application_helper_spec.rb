require 'rails_helper'

describe Wallaby::ApplicationHelper do
  describe '#url_for' do
    context 'when options is hash and has keys of action and resources' do
      it 'calls wallaby_resourceful_url_for' do
        expect(helper.url_for(resources: 'products', action: 'index')).to eq '/admin/products'
        expect(helper.url_for(parameters(resources: 'products', action: 'index'))).to eq '/admin/products'
      end
    end

    context 'otherwise' do
      it 'does not call wallaby_resourceful_url_for' do
        expect(helper.url_for('')).to eq ''
        expect(helper.url_for('/products')).to eq '/products'
      end
    end
  end

  describe '#wallaby_resourceful_url_for' do
    context 'when action is index/create' do
      it 'returns resources_path' do
        %w[index create].each do |action|
          expect(helper.wallaby_resourceful_url_for(resources: 'products', action: action)).to eq '/admin/products'
          expect(helper.wallaby_resourceful_url_for(parameters(resources: 'products', action: action))).to eq '/admin/products'
        end
      end
    end

    context 'when action is export' do
      it 'returns export_resources_path' do
        expect(helper.wallaby_resourceful_url_for(resources: 'products', action: 'export')).to eq '/admin/products/export'
        expect(helper.wallaby_resourceful_url_for(parameters(resources: 'products', action: 'export'))).to eq '/admin/products/export'
      end
    end

    context 'when action is new' do
      it 'returns new_resource_path' do
        expect(helper.wallaby_resourceful_url_for(resources: 'products', action: 'new')).to eq '/admin/products/new'
        expect(helper.wallaby_resourceful_url_for(parameters(resources: 'products', action: 'new'))).to eq '/admin/products/new'
      end
    end

    context 'when action is edit' do
      it 'returns edit_resource_path' do
        expect(helper.wallaby_resourceful_url_for(resources: 'products', action: 'edit', id: 1)).to eq '/admin/products/1/edit'
        expect(helper.wallaby_resourceful_url_for(parameters!(resources: 'products', action: 'edit', id: 1))).to eq '/admin/products/1/edit'
      end
    end

    context 'when action is show/update/destroy' do
      it 'returns resource_path' do
        %w[show update destroy].each do |action|
          expect(helper.wallaby_resourceful_url_for(resources: 'products', action: action, id: 1)).to eq '/admin/products/1'
          expect(helper.wallaby_resourceful_url_for(parameters!(resources: 'products', action: action, id: 1))).to eq '/admin/products/1'
        end
      end
    end

    context 'when options contains only_path' do
      it 'excludes only_path' do
        %w[index create new edit show update destroy].each do |action|
          uri = URI(helper.wallaby_resourceful_url_for(resources: 'products', id: 1, action: action, only_path: false))
          expect(uri.host).to be_blank

          uri = URI(helper.wallaby_resourceful_url_for(parameters!(resources: 'products', id: 1, action: action, only_path: false)))
          expect(uri.host).to be_blank
        end
      end
    end
  end

  describe '#stylesheet_link_tag' do
    it 'inclues data-turbolinks attribute' do
      expect(stylesheet_link_tag('application')).to include 'data-turbolinks-track="true"'
      expect(stylesheet_link_tag('application', 'data-turbolinks-track' => nil)).not_to include 'data-turbolinks-track'
    end
  end

  describe '#javascript_include_tag' do
    it 'inclues data-turbolinks attribute' do
      expect(javascript_include_tag('application')).to include 'data-turbolinks-track="true"'
      expect(javascript_include_tag('application')).to include 'data-turbolinks-eval="false"'
      expect(javascript_include_tag('application', 'data-turbolinks-track' => nil)).not_to include 'data-turbolinks-track'
      expect(javascript_include_tag('application', 'data-turbolinks-eval' => nil)).not_to include 'data-turbolinks-eval'
    end
  end
end
