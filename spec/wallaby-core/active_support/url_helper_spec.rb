# frozen_string_literal: true

require 'rails_helper'

describe 'URL helpers', type: :helper do
  describe 'action_view/routing_url_for' do
    it 'returns url' do
      super_method = helper.method(:url_for).super_method
      expect(super_method.call(parameters!(controller: 'application', action: 'index'))).to eq '/test/purpose'
    end
  end

  describe 'wallaby_engine.resources_path helper' do
    it 'returns url' do
      expect(helper.wallaby_engine.resources_path(action: 'index', resources: 'products', script_name: '/admin')).to eq '/admin/products'
      expect(helper.wallaby_engine.resources_path(action: 'index', resources: 'products')).to eq '/admin/products'
    end
  end
end
