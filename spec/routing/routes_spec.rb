require 'rails_helper'

describe 'routing' do
  describe 'general routes', type: :routing do
    routes { Wallaby::Engine.routes }
    it 'routes for general routes' do
      expect(get: '/').to route_to controller: 'wallaby/resources', action: 'home'
      expect(get: '/status').to route_to controller: 'wallaby/resources', action: 'healthy'
    end

    it 'routes for errors routes as well' do
      Wallaby::ERRORS.each do |status|
        code = Rack::Utils::SYMBOL_TO_STATUS_CODE[status]
        expect(get: code.to_s).to route_to action: status.to_s, controller: 'wallaby/resources'
        expect(get: status.to_s).to route_to action: status.to_s, controller: 'wallaby/resources'
      end
    end
  end

  describe 'resources routes', type: :request do
    let(:mocked_response) { double 'Response', call: [200, {}, ['Coming soon']] }
    let(:script_name) { '/admin' }

    it 'routes to the general resourceful routes' do
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

    context 'when target resources controller exists' do
      it 'routes to its resourceful routes' do
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
  end

  describe 'resource route helper', type: :request do
    it 'has the following helpers' do
      helpers = %w(resources new_resource edit_resource resource).map do |route_name|
        "#{route_name}_path"
      end
      helpers.each do |path|
        expect(wallaby_engine).to respond_to path
      end
    end
  end
end
