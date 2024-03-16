# frozen_string_literal: true

require 'rails_helper'

describe 'GlobalController', type: :request do
  before do
    stub_const 'GlobalController', (Class.new Wallaby::ResourcesController do
      base_class!
      before_action do
        response.headers['Test'] = 'Using GlobalController'
      end
    end)

    Wallaby.configuration.resources_controller = GlobalController
  end

  it 'uses the configured resources controller instead of ResourcesController' do
    get '/admin/pictures'
    expect(response).to be_successful
    expect(response.header['Test']).to eq 'Using GlobalController'
  end
end
