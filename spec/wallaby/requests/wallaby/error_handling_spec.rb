# frozen_string_literal: true

require 'rails_helper'

describe 'Error pages', type: :request do
  it 'shows not found for unknown model' do
    expect { get '/admin/unknown_model' }.to raise_error(ActionController::RoutingError)
  end
end
