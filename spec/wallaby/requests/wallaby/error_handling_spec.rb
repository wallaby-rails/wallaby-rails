# frozen_string_literal: true

require 'rails_helper'

describe 'Error pages', type: :request do
  it 'shows not found page for unknown model' do
    get '/admin/unknown_model'
    expect(response).to have_http_status :not_found
    expect(response).to render_template :error
    expect(response.body).to include 'Model UnknownModel cannot be found.'
  end

  it 'shows not found page for array' do
    get '/admin/array'
    expect(response).to have_http_status :unprocessable_entity
    expect(response).to render_template :error
    expect(response.body).to include 'Unable to handle model Array'
  end
end
