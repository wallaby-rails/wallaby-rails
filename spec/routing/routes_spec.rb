require 'rails_helper'

describe 'routing' do
  describe 'general routes', type: :routing do
    routes { Wallaby::Engine.routes }
    after do
      Wallaby.configuration.clear
      Rails.application.reload_routes!
    end

    it 'routes for general routes' do
      expect(get: '/').to route_to controller: 'wallaby/resources', action: 'home'
      expect(get: '/status').to route_to controller: 'wallaby/resources', action: 'healthy'
    end

    it 'routes for general routes to global controller if configured' do
      stub_const 'GlobalController', (Class.new Wallaby::ResourcesController)
      Wallaby.configuration.mapping.resources_controller = GlobalController
      Rails.application.reload_routes!
      expect(get: '/').to route_to controller: 'global', action: 'home'
      expect(get: '/status').to route_to controller: 'global', action: 'healthy'
    end

    it 'routes for errors routes' do
      Wallaby::ERRORS.each do |status|
        code = Rack::Utils::SYMBOL_TO_STATUS_CODE[status]
        expect(get: code.to_s).to route_to action: status.to_s, controller: 'wallaby/resources'
        expect(get: status.to_s).to route_to action: status.to_s, controller: 'wallaby/resources'
      end
    end

    it 'routes for errors routes to global controller if configured' do
      stub_const 'GlobalController', (Class.new Wallaby::ResourcesController)
      Wallaby.configuration.mapping.resources_controller = GlobalController
      Rails.application.reload_routes!
      Wallaby::ERRORS.each do |status|
        code = Rack::Utils::SYMBOL_TO_STATUS_CODE[status]
        expect(get: code.to_s).to route_to action: status.to_s, controller: 'global'
        expect(get: status.to_s).to route_to action: status.to_s, controller: 'global'
      end
    end
  end

  describe 'resources routes', type: :request do
    let(:mocked_response) { double 'Response', call: [200, {}, ['Coming soon']] }
    let(:script_name) { '/admin' }

    it 'routes for resourceful routes' do
      controller  = Wallaby::ResourcesController
      resources   = 'products'

      expect(controller).to receive(:action).with('index') { mocked_response }
      get "#{script_name}/#{resources}"

      expect(controller).to receive(:action).with('create') { mocked_response }
      post "#{script_name}/#{resources}"

      expect(controller).to receive(:action).with('new') { mocked_response }
      get "#{script_name}/#{resources}/new"

      expect(controller).to receive(:action).with('edit') { mocked_response }
      get "#{script_name}/#{resources}/1/edit"

      expect(controller).to receive(:action).with('show') { mocked_response }
      get "#{script_name}/#{resources}/1"

      expect(controller).to receive(:action).with('show') { mocked_response }
      get "#{script_name}/#{resources}/1-d"

      expect(controller).to receive(:action).with('update') { mocked_response }
      put "#{script_name}/#{resources}/1"

      expect(controller).to receive(:action).with('update') { mocked_response }
      patch "#{script_name}/#{resources}/1"

      expect(controller).to receive(:action).with('destroy') { mocked_response }
      delete "#{script_name}/#{resources}/1"

      expect { get "#{script_name}/#{resources}/1/history" }.to raise_error ActionController::RoutingError

      expect(controller).to receive(:action).with('show') { mocked_response }
      get "#{script_name}/#{resources}/history"
    end


    it 'routes to global controller if configured' do
      stub_const 'GlobalController', (Class.new Wallaby::ResourcesController)
      controller = Wallaby.configuration.mapping.resources_controller = GlobalController
      resources  = 'products'
      Rails.application.reload_routes!

      expect(controller).to receive(:action).with('index') { mocked_response }
      get "#{script_name}/#{resources}"

      expect(controller).to receive(:action).with('create') { mocked_response }
      post "#{script_name}/#{resources}"

      expect(controller).to receive(:action).with('new') { mocked_response }
      get "#{script_name}/#{resources}/new"

      expect(controller).to receive(:action).with('edit') { mocked_response }
      get "#{script_name}/#{resources}/1/edit"

      expect(controller).to receive(:action).with('show') { mocked_response }
      get "#{script_name}/#{resources}/1"

      expect(controller).to receive(:action).with('show') { mocked_response }
      get "#{script_name}/#{resources}/1-d"

      expect(controller).to receive(:action).with('update') { mocked_response }
      put "#{script_name}/#{resources}/1"

      expect(controller).to receive(:action).with('update') { mocked_response }
      patch "#{script_name}/#{resources}/1"

      expect(controller).to receive(:action).with('destroy') { mocked_response }
      delete "#{script_name}/#{resources}/1"

      expect { get "#{script_name}/#{resources}/1/history" }.to raise_error ActionController::RoutingError

      expect(controller).to receive(:action).with('show') { mocked_response }
      get "#{script_name}/#{resources}/history"
    end

    context 'when target resources controller exists' do
      it 'routes to this controller' do
        class Alien; end
        class AliensController < Wallaby::ResourcesController; def history; end; end

        controller  = AliensController
        resources   = 'aliens'

        expect(controller).to receive(:action).with('index') { mocked_response }
        get "#{script_name}/#{resources}"

        expect(controller).to receive(:action).with('create') { mocked_response }
        post "#{script_name}/#{resources}"

        expect(controller).to receive(:action).with('new') { mocked_response }
        get "#{script_name}/#{resources}/new"

        expect(controller).to receive(:action).with('edit') { mocked_response }
        get "#{script_name}/#{resources}/1/edit"

        expect(controller).to receive(:action).with('show') { mocked_response }
        get "#{script_name}/#{resources}/1"

        expect(controller).to receive(:action).with('show') { mocked_response }
        get "#{script_name}/#{resources}/1-d"

        expect(controller).to receive(:action).with('update') { mocked_response }
        put "#{script_name}/#{resources}/1"

        expect(controller).to receive(:action).with('update') { mocked_response }
        patch "#{script_name}/#{resources}/1"

        expect(controller).to receive(:action).with('destroy') { mocked_response }
        delete "#{script_name}/#{resources}/1"

        expect { get "#{script_name}/#{resources}/1/history" }.to raise_error ActionController::RoutingError

        expect(controller).to receive(:action).with('show') { mocked_response }
        get "#{script_name}/#{resources}/history"
      end
    end

    context 'when resources controller could not be found' do
      let(:mocked_response) { double 'Response', call: [404, {}, ['Not found']] }

      it 'routes to model not found' do
        expect(Wallaby::ResourcesController).to receive(:action).with(:not_found) { mocked_response }
        get "#{script_name}/unknown_models"
      end
    end
  end

  describe 'resource route helper', type: :request do
    it 'has the following helpers' do
      expect(wallaby_engine.resources_path('products')).to eq '/admin/products'
      expect(wallaby_engine.new_resource_path('products')).to eq '/admin/products/new'
      expect(wallaby_engine.resource_path('products', 1)).to eq '/admin/products/1'
      expect(wallaby_engine.edit_resource_path('products', 1)).to eq '/admin/products/1/edit'
    end
  end
end
