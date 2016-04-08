require 'rails_helper'

describe 'routing', type: :request, clear: :object_space do
  let(:mocked_response) { double 'Response', call: [ 200, {}, ["Coming soon"] ] }
  let(:script_name) { '/admin' }

  it 'routes to the general resourceful routes' do
    controller = Wallaby::ResourcesController
    resources = 'posts'

    expect(controller).to receive(:action).with('index') { mocked_response }
    get "#{ script_name }/#{ resources }"

    expect(controller).to receive(:action).with('create') { mocked_response }
    post "#{ script_name }/#{ resources }"

    expect(controller).to receive(:action).with('new') { mocked_response }
    get "#{ script_name }/#{ resources }/new"

    expect(controller).to receive(:action).with('edit') { mocked_response }
    get "#{ script_name }/#{ resources }/1/edit"

    expect(controller).to receive(:action).with('show') { mocked_response }
    get "#{ script_name }/#{ resources }/1"

    expect(controller).to receive(:action).with('show') { mocked_response }
    get "#{ script_name }/#{ resources }/1-d"

    expect(controller).to receive(:action).with('update') { mocked_response }
    put "#{ script_name }/#{ resources }/1"

    expect(controller).to receive(:action).with('update') { mocked_response }
    patch "#{ script_name }/#{ resources }/1"

    expect(controller).to receive(:action).with('destroy') { mocked_response }
    delete "#{ script_name }/#{ resources }/1"

    expect(controller).to receive(:action).with('history') { mocked_response }
    get "#{ script_name }/#{ resources }/1/history"
  end

  context 'when target resources controller exists' do
    it 'routes to the general resourceful routes' do
      controller = stub_const 'AliensController', Class.new(Wallaby::ResourcesController)
      resources = 'aliens'

      expect(controller).to receive(:action).with('index') { mocked_response }
      get "#{ script_name }/#{ resources }"

      expect(controller).to receive(:action).with('create') { mocked_response }
      post "#{ script_name }/#{ resources }"

      expect(controller).to receive(:action).with('new') { mocked_response }
      get "#{ script_name }/#{ resources }/new"

      expect(controller).to receive(:action).with('edit') { mocked_response }
      get "#{ script_name }/#{ resources }/1/edit"

      expect(controller).to receive(:action).with('show') { mocked_response }
      get "#{ script_name }/#{ resources }/1"

      expect(controller).to receive(:action).with('show') { mocked_response }
      get "#{ script_name }/#{ resources }/1-d"

      expect(controller).to receive(:action).with('update') { mocked_response }
      put "#{ script_name }/#{ resources }/1"

      expect(controller).to receive(:action).with('update') { mocked_response }
      patch "#{ script_name }/#{ resources }/1"

      expect(controller).to receive(:action).with('destroy') { mocked_response }
      delete "#{ script_name }/#{ resources }/1"

      expect(controller).to receive(:action).with('history') { mocked_response }
      get "#{ script_name }/#{ resources }/1/history"
    end
  end

  describe 'general routes' do
    it 'routes for general routes' do
      controller = Wallaby::CoreController

      expect(controller).to receive(:action).with('home') { mocked_response }
      get "#{ script_name }"

      expect(controller).to receive(:action).with('status') { mocked_response }
      get "#{ script_name }/status"
    end
  end
end
