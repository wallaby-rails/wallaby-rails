require 'rails_helper'

describe 'Error pages' do
  it 'shows not found page for unknown model' do
    get '/admin/unknown_model'
    expect(response).to have_http_status :not_found
    expect(response.body).to include 'Model unknown_model can not be found.'
  end

  it 'shows not found page for array' do
    get '/admin/array'
    expect(response).to have_http_status :unprocessable_entity
    expect(response.body).to include 'Unable to handle model Array'
  end
end
