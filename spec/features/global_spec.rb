require 'rails_helper'

describe 'Global', type: :request do
  after { Wallaby.configuration.clear }

  describe 'Controller' do
    before do
      stub_const 'GlobalController', (Class.new Wallaby::ResourcesController do
        before_action do
          response.headers['Test'] = 'Using GlobalController'
        end
      end)

      Wallaby.configuration.mapping.resources_controller = GlobalController
    end

    it 'uses the configured resources controller instead of ResourcesController' do
      get '/admin/pictures'
      expect(response).to be_successful
      expect(response.header['Test']).to eq 'Using GlobalController'
    end
  end

  describe 'Decorator' do
    before do
      stub_const 'GlobalDecorator', (Class.new Wallaby::ResourceDecorator do
        def to_label
          'Using GlobalDecorator'
        end
      end)

      Wallaby.configuration.mapping.resource_decorator = GlobalDecorator
    end

    it 'uses the configured resources decorator instead of ResourcesDecorator' do
      picture = Picture.create! name: 'a picture'
      get "/admin/pictures/#{picture.id}"
      expect(response).to be_successful
      expect(response.body).to include 'Using GlobalDecorator'
    end
  end
end
