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

  describe '#render' do
    it 'adds caller path to view_paths' do
      helper.render '/wallaby/shared/flash_messages'
      expect(helper.view_paths.map(&:to_path).last).to match %r(lib/action_view\Z)
    end
  end

  describe '#wallaby_resourceful_url_for' do
    context 'when action is index/create' do
      it 'returns resources_path' do
        %w( index create ).each do |action|
          expect(helper.wallaby_resourceful_url_for resources: 'products', action: action).to match %r(/[^/]+/products)
        end
      end
    end

    context 'when action is new' do
      it 'returns new_resource_path' do
        expect(helper.wallaby_resourceful_url_for resources: 'products', action: 'new').to match %r(/[^/]+/products/new)
      end
    end

    context 'when action is edit' do
      it 'returns edit_resource_path' do
        expect(helper.wallaby_resourceful_url_for resources: 'products', action: 'edit', id: 1).to match %r(/[^/]+/products/1/edit)
      end
    end

    context 'when action is show/update/destroy' do
      it 'returns resource_path' do
        %w( show update destroy ).each do |action|
          expect(helper.wallaby_resourceful_url_for resources: 'products', action: action, id: 1).to match %r(/[^/]+/products/1)
        end
      end
    end

    context 'when options contains only_path' do
      it 'excludes only_path' do
        %w( index create new edit show update destroy ).each do |action|
          uri = URI(helper.wallaby_resourceful_url_for resources: 'products', id: 1, action: action, only_path: false)
          expect(uri.host).to be_blank
        end
      end
    end
  end
end