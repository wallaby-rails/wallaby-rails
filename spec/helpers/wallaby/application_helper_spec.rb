require 'rails_helper'

describe Wallaby::ApplicationHelper do
  describe '#url_for' do
    context 'when options is hash and has keys of action and resources' do
      it 'calls wallaby_resourceful_url_for' do
        expect(helper).to receive(:wallaby_resourceful_url_for)
        helper.url_for resources: 'products', action: 'action'
      end
    end

    context 'otherwise' do
      it 'does not call wallaby_resourceful_url_for' do
        allow_any_instance_of(ActionDispatch::Routing::RouteSet).to receive(:url_for)
        expect(helper).not_to receive(:wallaby_resourceful_url_for)
        helper.url_for nil
        helper.url_for '/products'
        helper.url_for resources: 'products'
        helper.url_for action: 'action'
      end
    end
  end

  describe '#wallaby_resourceful_url_for' do
    context 'when action is index/create' do
      it 'returns resources_path' do
        %w[index create].each do |action|
          expect(helper.wallaby_resourceful_url_for(resources: 'products', action: action)).to match(%r{/[^/]+/products})
        end
      end
    end

    context 'when action is new' do
      it 'returns new_resource_path' do
        expect(helper.wallaby_resourceful_url_for(resources: 'products', action: 'new')).to match(%r{/[^/]+/products/new})
      end
    end

    context 'when action is edit' do
      it 'returns edit_resource_path' do
        expect(helper.wallaby_resourceful_url_for(resources: 'products', action: 'edit', id: 1)).to match(%r{/[^/]+/products/1/edit})
      end
    end

    context 'when action is show/update/destroy' do
      it 'returns resource_path' do
        %w[show update destroy].each do |action|
          expect(helper.wallaby_resourceful_url_for(resources: 'products', action: action, id: 1)).to match(%r{/[^/]+/products/1})
        end
      end
    end

    context 'when options contains only_path' do
      it 'excludes only_path' do
        %w[index create new edit show update destroy].each do |action|
          uri = URI(helper.wallaby_resourceful_url_for(resources: 'products', id: 1, action: action, only_path: false))
          expect(uri.host).to be_blank
        end
      end
    end
  end

  describe '#stylesheet_link_tag' do
    it 'inclues data-turbolinks attribute' do
      expect(stylesheet_link_tag('application')).to include "data-turbolinks-track=\"true\""
      expect(stylesheet_link_tag('application', 'data-turbolinks-track' => nil)).not_to include 'data-turbolinks-track'
    end
  end

  describe '#javascript_include_tag' do
    it 'inclues data-turbolinks attribute' do
      expect(javascript_include_tag('application')).to include "data-turbolinks-track=\"true\""
      expect(javascript_include_tag('application')).to include "data-turbolinks-eval=\"false\""
      expect(javascript_include_tag('application', 'data-turbolinks-track' => nil)).not_to include 'data-turbolinks-track'
      expect(javascript_include_tag('application', 'data-turbolinks-eval' => nil)).not_to include 'data-turbolinks-eval'
    end
  end
end
