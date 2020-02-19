require 'rails_helper'

describe 'JSON API' do
  it 'lists collection' do
    picture1 = Picture.create name: 'picture1'
    picture2 = Picture.create name: 'picture2'
    picture3 = Picture.create name: 'picture3'
    http :get, '/api/pictures'
    expect(response.headers['Content-Type']).to include 'application/vnd.api+json'
    json = JSON.parse response.body
    expect(json['data'][0]).to include 'id' => picture1.id, 'type' => 'pictures'
    expect(json['data'][0]['attributes']).to include 'id' => picture1.id, 'name' => picture1.name
    expect(json['data'][1]).to include 'id' => picture2.id, 'type' => 'pictures'
    expect(json['data'][1]['attributes']).to include 'id' => picture2.id, 'name' => picture2.name
    expect(json['data'][2]).to include 'id' => picture3.id, 'type' => 'pictures'
    expect(json['data'][2]['attributes']).to include 'id' => picture3.id, 'name' => picture3.name
    expect(json['links']['self']).to include '/api/pictures'
  end

  it 'shows resource' do
    picture = Picture.create name: 'beautiful'
    http :get, "/api/pictures/#{picture.id}"
    expect(response.headers['Content-Type']).to include 'application/vnd.api+json'
    json = JSON.parse response.body
    expect(json['data']).to include 'id' => picture.id, 'type' => 'pictures'
    expect(json['data']['attributes']).to include 'id' => picture.id, 'name' => picture.name
    expect(json['links']['self']).to include "/api/pictures/#{picture.id}"
  end

  it 'creates resource' do
    http :post, '/api/pictures', params: { picture: { name: 'beautiful' } }
    picture = Picture.last
    expect(response.headers['Content-Type']).to include 'application/vnd.api+json'
    json = JSON.parse response.body
    expect(json['data']).to include 'id' => be_an(Integer), 'type' => 'pictures'
    expect(json['data']['attributes']).to include 'id' => be_an(Integer), 'name' => 'beautiful'
    expect(json['links']['self']).to include "/api/pictures/#{picture.id}"
  end

  context 'when params is missing for create' do
    it 'shows error' do
      http :post, '/api/pictures'
      expect(response).to have_http_status :bad_request
      expect(response.headers['Content-Type']).to include 'application/vnd.api+json'
      json = JSON.parse response.body
      expect(json['errors']).to eq [{ 'detail' => 'param is missing or the value is empty: picture', 'status' => 400 }]
    end
  end

  context 'when name is missing for create' do
    it 'shows error' do
      http :post, '/api/pictures', params: { picture: { test: 'test' } }
      expect(response).to have_http_status :unprocessable_entity
      expect(response.headers['Content-Type']).to include 'application/vnd.api+json'
      json = JSON.parse response.body
      expect(json['errors']).to eq [{ 'detail' => "can't be blank", 'source' => { 'pointer' => '/data/attributes/name' }, 'status' => 422 }]
    end
  end

  it 'updates resource' do
    picture = Picture.create name: 'beautiful'
    http :put, "/api/pictures/#{picture.id}", params: { picture: { name: 'splendid' } }
    expect(response.headers['Content-Type']).to include 'application/vnd.api+json'
    json = JSON.parse response.body
    expect(json['data']).to include 'id' => picture.id, 'type' => 'pictures'
    expect(json['data']['attributes']).to include 'id' => picture.id, 'name' => 'splendid'
    expect(json['links']['self']).to include "/api/pictures/#{picture.id}"
  end

  context 'when params is missing for update' do
    it 'shows error' do
      picture = Picture.create name: 'beautiful'
      http :put, "/api/pictures/#{picture.id}"
      expect(response).to have_http_status :bad_request
      expect(response.headers['Content-Type']).to include 'application/vnd.api+json'
      json = JSON.parse response.body
      expect(json['errors']).to eq [{ 'detail' => 'param is missing or the value is empty: picture', 'status' => 400 }]
    end
  end

  context 'when name is missing for update' do
    it 'shows error' do
      picture = Picture.create name: 'beautiful'
      http :put, "/api/pictures/#{picture.id}", params: { picture: { name: '' } }
      expect(response).to have_http_status :unprocessable_entity
      expect(response.headers['Content-Type']).to include 'application/vnd.api+json'
      json = JSON.parse response.body
      expect(json['errors']).to eq [{ 'detail' => "can't be blank", 'source' => { 'pointer' => '/data/attributes/name' }, 'status' => 422 }]
    end
  end

  it 'deletes resource' do
    picture = Picture.create name: 'beautiful'
    http :delete, "/api/pictures/#{picture.id}"
    expect(response.headers['Content-Type']).to include 'application/vnd.api+json'
    json = JSON.parse response.body
    expect(json['data']).to include 'id' => picture.id, 'type' => 'pictures'
    expect(json['data']['attributes']).to include 'id' => picture.id, 'name' => 'beautiful'
    expect(json['links']['self']).to include "/api/pictures/#{picture.id}"
  end
end
