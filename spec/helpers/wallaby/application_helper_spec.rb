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

    context 'when script name is blank' do
      it 'generates the correct url', script_name: '' do
        expect(helper.url_for(parameters(controller: 'wallaby/resources', resources: 'products', action: 'index'))).to eq '/products'
        expect(helper.url_for(parameters(controller: 'wallaby/resources', resources: 'pictures', action: 'index'))).to eq '/pictures'
      end
    end
  end

  describe '#stylesheet_link_tag' do
    it 'inclues data-turbolinks attribute' do
      expect(stylesheet_link_tag('application')).not_to include 'data-turbolinks-track="true"'
      Wallaby.configuration.features.turbolinks_enabled = true
      expect(stylesheet_link_tag('application')).to include 'data-turbolinks-track="true"'
      expect(stylesheet_link_tag('application', 'data-turbolinks-track' => nil)).not_to include 'data-turbolinks-track'
    end
  end

  describe '#javascript_include_tag' do
    it 'inclues data-turbolinks attribute' do
      expect(javascript_include_tag('application')).not_to include 'data-turbolinks-track="true"'
      expect(javascript_include_tag('application')).not_to include 'data-turbolinks-eval="false"'
      Wallaby.configuration.features.turbolinks_enabled = true
      expect(javascript_include_tag('application')).to include 'data-turbolinks-track="true"'
      expect(javascript_include_tag('application')).to include 'data-turbolinks-eval="false"'
      expect(javascript_include_tag('application', 'data-turbolinks-track' => nil)).not_to include 'data-turbolinks-track'
      expect(javascript_include_tag('application', 'data-turbolinks-eval' => nil)).not_to include 'data-turbolinks-eval'
    end
  end
end
