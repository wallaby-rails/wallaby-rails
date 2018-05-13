require 'rails_helper'

describe 'routing' do
  describe 'resources router', type: :request do
    # NOTE: this is to test the request being dispatched to the correct controler and action
    # it does not test the actual action, see integration test for more
    def mock_response_with(body)
      double('Response', call: [200, {}, [body]])
    end
    let!(:global_controller) { stub_const 'GlobalController', (Class.new Wallaby::ResourcesController) }
    let(:script_name) { '/admin' }

    it 'dispatches general routes to expected controller and action' do
      controller = Wallaby::ResourcesController
      expect(controller).to receive(:action).with('home') { mock_response_with('home_body') }
      get script_name
      expect(response.body).to eq 'home_body'

      expect(controller).to receive(:action).with('healthy') { mock_response_with('status_body') }
      get "#{script_name}/status"
      expect(response.body).to eq 'status_body'
    end

    it 'dispatches general routes to global controller and expected action if configured' do
      controller = Wallaby.configuration.mapping.resources_controller = global_controller
      expect(controller).to receive(:action).with('home') { mock_response_with('home_body') }
      get script_name
      expect(response.body).to eq 'home_body'

      expect(controller).to receive(:action).with('healthy') { mock_response_with('status_body') }
      get "#{script_name}/status"
      expect(response.body).to eq 'status_body'
    end

    it 'dispatches error routes to expected controller and action' do
      controller = Wallaby::ResourcesController
      Wallaby::ERRORS.each do |status|
        code = Rack::Utils::SYMBOL_TO_STATUS_CODE[status]
        expect(controller).to receive(:action).with(status) { mock_response_with(code.to_s) }
        get "#{script_name}/#{code}"
        expect(response.body).to eq code.to_s

        expect(controller).to receive(:action).with(status) { mock_response_with(status.to_s) }
        get "#{script_name}/#{status}"
        expect(response.body).to eq status.to_s
      end
    end

    it 'dispatches error routes to global controller and expected action if configured' do
      controller = Wallaby.configuration.mapping.resources_controller = global_controller
      Wallaby::ERRORS.each do |status|
        code = Rack::Utils::SYMBOL_TO_STATUS_CODE[status]
        expect(controller).to receive(:action).with(status) { mock_response_with(code.to_s) }
        get "#{script_name}/#{code}"
        expect(response.body).to eq code.to_s

        expect(controller).to receive(:action).with(status) { mock_response_with(status.to_s) }
        get "#{script_name}/#{status}"
        expect(response.body).to eq status.to_s
      end
    end

    it 'dispatches resourceful routes to expected controller and action' do
      controller  = Wallaby::ResourcesController
      resources   = 'products'

      expect(controller).to receive(:action).with('index') { mock_response_with('index_body') }
      get "#{script_name}/#{resources}"
      expect(response.body).to eq 'index_body'

      expect(controller).to receive(:action).with('create') { mock_response_with('create_body') }
      post "#{script_name}/#{resources}"
      expect(response.body).to eq 'create_body'

      expect(controller).to receive(:action).with('new') { mock_response_with('new_body') }
      get "#{script_name}/#{resources}/new"
      expect(response.body).to eq 'new_body'

      expect(controller).to receive(:action).with('edit') { mock_response_with('edit_body') }
      get "#{script_name}/#{resources}/1/edit"
      expect(response.body).to eq 'edit_body'

      expect(controller).to receive(:action).with('show') { mock_response_with('show_body') }
      get "#{script_name}/#{resources}/1"
      expect(response.body).to eq 'show_body'

      expect(controller).to receive(:action).with('show') { mock_response_with('show_body') }
      get "#{script_name}/#{resources}/1-d"
      expect(response.body).to eq 'show_body'

      expect(controller).to receive(:action).with('update') { mock_response_with('update_body') }
      put "#{script_name}/#{resources}/1"
      expect(response.body).to eq 'update_body'

      expect(controller).to receive(:action).with('update') { mock_response_with('update_body') }
      patch "#{script_name}/#{resources}/1"
      expect(response.body).to eq 'update_body'

      expect(controller).to receive(:action).with('destroy') { mock_response_with('destroy_body') }
      delete "#{script_name}/#{resources}/1"
      expect(response.body).to eq 'destroy_body'

      expect { get "#{script_name}/#{resources}/1/history" }.to raise_error ActionController::RoutingError

      expect(controller).to receive(:action).with('show') { mock_response_with('show_body') }
      get "#{script_name}/#{resources}/history"
      expect(response.body).to eq 'show_body'
    end

    it 'routes to global controller if configured' do
      stub_const 'GlobalController', (Class.new Wallaby::ResourcesController)
      controller = Wallaby.configuration.mapping.resources_controller = GlobalController
      resources  = 'products'

      expect(controller).to receive(:action).with('index') { mock_response_with('index_body') }
      get "#{script_name}/#{resources}"
      expect(response.body).to eq 'index_body'

      expect(controller).to receive(:action).with('create') { mock_response_with('create_body') }
      post "#{script_name}/#{resources}"
      expect(response.body).to eq 'create_body'

      expect(controller).to receive(:action).with('new') { mock_response_with('new_body') }
      get "#{script_name}/#{resources}/new"
      expect(response.body).to eq 'new_body'

      expect(controller).to receive(:action).with('edit') { mock_response_with('edit_body') }
      get "#{script_name}/#{resources}/1/edit"
      expect(response.body).to eq 'edit_body'

      expect(controller).to receive(:action).with('show') { mock_response_with('show_body') }
      get "#{script_name}/#{resources}/1"
      expect(response.body).to eq 'show_body'

      expect(controller).to receive(:action).with('show') { mock_response_with('show_body') }
      get "#{script_name}/#{resources}/1-d"
      expect(response.body).to eq 'show_body'

      expect(controller).to receive(:action).with('update') { mock_response_with('update_body') }
      put "#{script_name}/#{resources}/1"
      expect(response.body).to eq 'update_body'

      expect(controller).to receive(:action).with('update') { mock_response_with('update_body') }
      patch "#{script_name}/#{resources}/1"
      expect(response.body).to eq 'update_body'

      expect(controller).to receive(:action).with('destroy') { mock_response_with('destroy_body') }
      delete "#{script_name}/#{resources}/1"
      expect(response.body).to eq 'destroy_body'

      expect { get "#{script_name}/#{resources}/1/history" }.to raise_error ActionController::RoutingError

      expect(controller).to receive(:action).with('show') { mock_response_with('show_body') }
      get "#{script_name}/#{resources}/history"
      expect(response.body).to eq 'show_body'
    end

    context 'when target resources controller exists' do
      it 'routes to this controller' do
        class Alien; end
        class AliensController < Wallaby::ResourcesController; def history; end; end

        controller  = AliensController
        resources   = 'aliens'

        expect(controller).to receive(:action).with('index') { mock_response_with('index_body') }
        get "#{script_name}/#{resources}"
        expect(response.body).to eq 'index_body'

        expect(controller).to receive(:action).with('create') { mock_response_with('create_body') }
        post "#{script_name}/#{resources}"
        expect(response.body).to eq 'create_body'

        expect(controller).to receive(:action).with('new') { mock_response_with('new_body') }
        get "#{script_name}/#{resources}/new"
        expect(response.body).to eq 'new_body'

        expect(controller).to receive(:action).with('edit') { mock_response_with('edit_body') }
        get "#{script_name}/#{resources}/1/edit"
        expect(response.body).to eq 'edit_body'

        expect(controller).to receive(:action).with('show') { mock_response_with('show_body') }
        get "#{script_name}/#{resources}/1"
        expect(response.body).to eq 'show_body'

        expect(controller).to receive(:action).with('show') { mock_response_with('show_body') }
        get "#{script_name}/#{resources}/1-d"
        expect(response.body).to eq 'show_body'

        expect(controller).to receive(:action).with('update') { mock_response_with('update_body') }
        put "#{script_name}/#{resources}/1"
        expect(response.body).to eq 'update_body'

        expect(controller).to receive(:action).with('update') { mock_response_with('update_body') }
        patch "#{script_name}/#{resources}/1"
        expect(response.body).to eq 'update_body'

        expect(controller).to receive(:action).with('destroy') { mock_response_with('destroy_body') }
        delete "#{script_name}/#{resources}/1"
        expect(response.body).to eq 'destroy_body'

        expect { get "#{script_name}/#{resources}/1/history" }.to raise_error ActionController::RoutingError

        expect(controller).to receive(:action).with('show') { mock_response_with('show_body') }
        get "#{script_name}/#{resources}/history"
        expect(response.body).to eq 'show_body'
      end
    end

    context 'when resources controller could not be found' do
      it 'routes to model not found' do
        expect(Wallaby::ResourcesController).to receive(:action).with(:not_found) { mock_response_with('not_found_body') }
        get "#{script_name}/unknown_models"
        expect(response.body).to eq 'not_found_body'
      end
    end
  end

  describe 'resource route helper', type: :request do
    it 'has the following helpers' do
      expect(wallaby_engine.resources_path('products')).to eq '/admin/products'
      expect(wallaby_engine.new_resource_path('products')).to eq '/admin/products/new'
      expect(wallaby_engine.resource_path('products', 1)).to eq '/admin/products/1'
      expect(wallaby_engine.edit_resource_path('products', 1)).to eq '/admin/products/1/edit'

      if Rails::VERSION::MAJOR == 5 && Rails::VERSION::MINOR > 0
        expect(manager_engine.resources_path('products')).to eq '/admin_else/products'
        expect(manager_engine.new_resource_path('products')).to eq '/admin_else/products/new'
        expect(manager_engine.resource_path('products', 1)).to eq '/admin_else/products/1'
        expect(manager_engine.edit_resource_path('products', 1)).to eq '/admin_else/products/1/edit'
      end
    end
  end
end
