require 'rails_helper'

describe 'Global' do
  after { Wallaby.configuration.clear }

  describe 'Controller', type: :request do
    before do
      stub_const 'GlobalController', (Class.new(Wallaby::ResourcesController) do
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
end
