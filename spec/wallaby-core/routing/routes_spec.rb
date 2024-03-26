# frozen_string_literal: true

require 'rails_helper'

describe 'routing' do
  def mock_response_with(body)
    proc { [200, {}, [body]] }
  end

  describe 'status', type: :routing do
    routes { Wallaby::Engine.routes }
    it { expect(get: 'status').to route_to controller: 'wallaby/resources', action: 'healthy' }
  end

  # NOTE: this is a spec to specify that the request being dispatched to the correct controler and action
  # it does not test the actual action, see integration test for more
  describe 'resources router', type: :request do
    let(:script_name) { '/admin' }
    let(:configuration_resources_controller) { nil }

    before do
      Wallaby.configuration.resources_controller = configuration_resources_controller
    end

    shared_examples 'dispatching resourceful routes' do
      it 'dispatches the routes to controllers and actions' do
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

        expect(controller).to receive(:action).with('update') { mock_response_with('update_body') }
        put "#{script_name}/#{resources}/1"
        expect(response.body).to eq 'update_body'

        expect(controller).to receive(:action).with('update') { mock_response_with('update_body') }
        patch "#{script_name}/#{resources}/1"
        expect(response.body).to eq 'update_body'

        expect(controller).to receive(:action).with('destroy') { mock_response_with('destroy_body') }
        delete "#{script_name}/#{resources}/1"
        expect(response.body).to eq 'destroy_body'

        expect(controller).to receive(:action).with('edit') { mock_response_with('edit_body') }
        get "#{script_name}/#{resources}/accd4e99-1bff-4f79-a956-3ea003373ddc/edit"
        expect(response.body).to eq 'edit_body'

        expect(controller).to receive(:action).with('show') { mock_response_with('show_body') }
        get "#{script_name}/#{resources}/accd4e99-1bff-4f79-a956-3ea003373ddc"
        expect(response.body).to eq 'show_body'

        expect(controller).to receive(:action).with('update') { mock_response_with('update_body') }
        put "#{script_name}/#{resources}/accd4e99-1bff-4f79-a956-3ea003373ddc"
        expect(response.body).to eq 'update_body'

        expect(controller).to receive(:action).with('update') { mock_response_with('update_body') }
        patch "#{script_name}/#{resources}/accd4e99-1bff-4f79-a956-3ea003373ddc"
        expect(response.body).to eq 'update_body'

        expect(controller).to receive(:action).with('destroy') { mock_response_with('destroy_body') }
        delete "#{script_name}/#{resources}/accd4e99-1bff-4f79-a956-3ea003373ddc"
        expect(response.body).to eq 'destroy_body'

        expect(controller).to receive(:action).with('show') { mock_response_with('show_body') }
        get "#{script_name}/#{resources}/history"
        expect(response.body).to eq 'show_body'
      end

      it 'raises routing errors' do
        expect { get "#{script_name}/#{resources}/1/history" }.to raise_error(ActionController::RoutingError)
        expect { get "#{script_name}/#{resources}_/history" }.to raise_error(ActionController::RoutingError)
        expect { get "#{script_name}/-#{resources}/1" }.to raise_error(ActionController::RoutingError)
        expect { get "#{script_name}/_#{resources}/1" }.to raise_error(ActionController::RoutingError)
        expect { get "#{script_name}/1#{resources}/1" }.to raise_error(ActionController::RoutingError)
      end
    end

    context 'with /admin' do
      it 'dispatches landing routes to Admin::ApplicationController' do
        expect(Admin::ApplicationController).to receive(:action).with('home') { mock_response_with('home_body') }
        get script_name
        expect(response.body).to eq 'home_body'
      end

      it 'dispatches error routes to Admin::ApplicationController' do
        Wallaby::ERRORS.each do |status|
          code = Rack::Utils::SYMBOL_TO_STATUS_CODE[status]
          expect(Admin::ApplicationController).to receive(:action).with(status.to_s) { mock_response_with(code.to_s) }
          get "#{script_name}/#{code}"
          expect(response.body).to eq code.to_s

          expect(Admin::ApplicationController).to receive(:action).with(status.to_s) { mock_response_with(status.to_s) }
          get "#{script_name}/#{status}"
          expect(response.body).to eq status.to_s
        end
      end

      it_behaves_like 'dispatching resourceful routes' do
        let(:controller) { Admin::ApplicationController }
        let(:resources) { 'products' }
      end

      context 'when configuration.resources_controller is set' do
        let(:configuration_resources_controller) { CoreController }

        it 'dispatches landing routes to CoreController' do
          expect(CoreController).to receive(:action).with('home') { mock_response_with('home_body') }
          get script_name
          expect(response.body).to eq 'home_body'
        end

        it 'dispatches error routes to CoreController' do
          Wallaby::ERRORS.each do |status|
            code = Rack::Utils::SYMBOL_TO_STATUS_CODE[status]
            expect(CoreController).to receive(:action).with(status.to_s) { mock_response_with(code.to_s) }
            get "#{script_name}/#{code}"
            expect(response.body).to eq code.to_s

            expect(CoreController).to receive(:action).with(status.to_s) { mock_response_with(status.to_s) }
            get "#{script_name}/#{status}"
            expect(response.body).to eq status.to_s
          end
        end

        it_behaves_like 'dispatching resourceful routes' do
          let(:controller) { CoreController }
          let(:resources) { 'products' }
        end
      end
    end

    context 'with /inner' do
      let(:script_name) { '/inner' }

      it 'dispatches landing routes to InnerController' do
        expect(InnerController).to receive(:action).with('home') { mock_response_with('home_body') }
        get script_name
        expect(response.body).to eq 'home_body'
      end

      it 'dispatches error routes to InnerController' do
        Wallaby::ERRORS.each do |status|
          code = Rack::Utils::SYMBOL_TO_STATUS_CODE[status]
          expect(InnerController).to receive(:action).with(status.to_s) { mock_response_with(code.to_s) }
          get "#{script_name}/#{code}"
          expect(response.body).to eq code.to_s

          expect(InnerController).to receive(:action).with(status.to_s) { mock_response_with(status.to_s) }
          get "#{script_name}/#{status}"
          expect(response.body).to eq status.to_s
        end
      end

      it_behaves_like 'dispatching resourceful routes' do
        let(:controller) { InnerController }
        let(:resources) { 'products' }
      end

      context 'when configuration.resources_controller is set' do
        let(:configuration_resources_controller) { CoreController }

        it 'dispatches landing routes to InnerController' do
          expect(InnerController).to receive(:action).with('home') { mock_response_with('home_body') }
          get script_name
          expect(response.body).to eq 'home_body'
        end

        it_behaves_like 'dispatching resourceful routes' do
          let(:controller) { InnerController }
          let(:resources) { 'products' }
        end
      end
    end

    context 'with /before_engine' do
      let(:script_name) { '/before_engine' }

      it 'dispatches landing routes to Admin::ApplicationController' do
        expect(Admin::ApplicationController).to receive(:action).with('home') { mock_response_with('home_body') }
        get script_name
        expect(response.body).to eq 'home_body'
      end
    end

    context 'when target resources controller exists' do
      context 'with order/items' do
        it_behaves_like 'dispatching resourceful routes' do
          let(:controller) { Admin::Order::ItemsController }
          let(:base_controller) { Admin::ApplicationController }
          let(:resources) { 'order/items' }
        end
      end

      context 'with orders/items' do
        it_behaves_like 'dispatching resourceful routes' do
          let(:controller) { Admin::ApplicationController }
          let(:resources) { 'orders/items' }
        end
      end
    end

    context 'when model not found' do
      specify do
        expect { get "#{script_name}/unknown_models" }.to raise_error(ActionController::RoutingError)
      end
    end
  end

  # NOTE: this is a spec to specify that the request being dispatched to the correct controler and action
  # it does not test the actual action, see integration test for more
  describe 'resource route helper', type: :request do
    it 'has the following helpers' do
      script_name = '/admin'
      expect(wallaby_engine.resources_path('products', script_name: script_name)).to eq '/admin/products'
      expect(wallaby_engine.new_resource_path('products', script_name: script_name)).to eq '/admin/products/new'
      expect(wallaby_engine.resource_path('products', 1, script_name: script_name)).to eq '/admin/products/1'
      expect(wallaby_engine.edit_resource_path('products', 1, script_name: script_name)).to eq '/admin/products/1/edit'
    end
  end
end
