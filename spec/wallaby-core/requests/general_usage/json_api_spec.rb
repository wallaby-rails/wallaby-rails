# frozen_string_literal: true

require 'rails_helper'

describe 'for Json API', type: :request do
  context 'when it inherits from ApplicationController and includes ResourcesConcern' do
    it 'lists collection' do
      picture1 = Picture.create name: 'picture1'
      picture2 = Picture.create name: 'picture2'
      picture3 = Picture.create name: 'picture3'
      http :get, app_pictures_path
      expect(response.headers['Content-Type']).to include 'application/vnd.api+json'
      json = JSON.parse response.body
      expect(json['data'][0]).to include 'id' => picture1.id, 'type' => 'pictures'
      expect(json['data'][0]['attributes']).to include 'id' => picture1.id, 'name' => picture1.name
      expect(json['data'][1]).to include 'id' => picture2.id, 'type' => 'pictures'
      expect(json['data'][1]['attributes']).to include 'id' => picture2.id, 'name' => picture2.name
      expect(json['data'][2]).to include 'id' => picture3.id, 'type' => 'pictures'
      expect(json['data'][2]['attributes']).to include 'id' => picture3.id, 'name' => picture3.name
      expect(json['links']['self']).to include app_pictures_path
    end

    it 'shows resource' do
      picture = Picture.create name: 'beautiful'
      http :get, app_picture_path(picture)
      expect(response.headers['Content-Type']).to include 'application/vnd.api+json'
      json = JSON.parse response.body
      expect(json['data']).to include 'id' => picture.id, 'type' => 'pictures'
      expect(json['data']['attributes']).to include 'id' => picture.id, 'name' => picture.name
      expect(json['links']['self']).to include app_picture_path(picture)
    end

    it 'creates resource' do
      http :post, app_pictures_path, params: { picture: { name: 'beautiful' } }
      picture = Picture.last
      expect(response.headers['Content-Type']).to include 'application/vnd.api+json'
      json = JSON.parse response.body
      expect(json['data']).to include 'id' => be_an(Integer), 'type' => 'pictures'
      expect(json['data']['attributes']).to include 'id' => be_an(Integer), 'name' => 'beautiful'
      expect(json['links']['self']).to include app_picture_path(picture)
    end

    context 'when params is missing for create' do
      it 'shows error' do
        http :post, app_pictures_path
        expect(response).to have_http_status :bad_request
        expect(response.headers['Content-Type']).to include 'application/vnd.api+json'
        json = JSON.parse response.body
        expect(json['errors']).to include('detail' => a_string_including('param is missing or the value is empty: picture'), 'status' => 400)
      end
    end

    context 'when name is missing for create' do
      it 'shows error' do
        http :post, app_pictures_path, params: { picture: { test: 'test' } }
        expect(response).to have_http_status :unprocessable_entity
        expect(response.headers['Content-Type']).to include 'application/vnd.api+json'
        json = JSON.parse response.body
        expect(json['errors']).to include('detail' => a_string_including("can't be blank"), 'source' => { 'pointer' => '/data/attributes/name' }, 'status' => 422)
      end
    end

    it 'updates resource' do
      picture = Picture.create name: 'beautiful'
      http :put, app_picture_path(picture), params: { picture: { name: 'splendid' } }
      expect(response.headers['Content-Type']).to include 'application/vnd.api+json'
      json = JSON.parse response.body
      expect(json['data']).to include 'id' => picture.id, 'type' => 'pictures'
      expect(json['data']['attributes']).to include 'id' => picture.id, 'name' => 'splendid'
      expect(json['links']['self']).to include app_picture_path(picture)
    end

    context 'when params is missing for update' do
      it 'shows error' do
        picture = Picture.create name: 'beautiful'
        http :put, app_picture_path(picture)
        expect(response).to have_http_status :bad_request
        expect(response.headers['Content-Type']).to include 'application/vnd.api+json'
        json = JSON.parse response.body
        expect(json['errors']).to include('detail' => a_string_including('param is missing or the value is empty: picture'), 'status' => 400)
      end
    end

    context 'when name is missing for update' do
      it 'shows error' do
        picture = Picture.create name: 'beautiful'
        http :put, app_picture_path(picture), params: { picture: { name: '' } }
        expect(response).to have_http_status :unprocessable_entity
        expect(response.headers['Content-Type']).to include 'application/vnd.api+json'
        json = JSON.parse response.body
        expect(json['errors']).to include('detail' => a_string_including("can't be blank"), 'source' => { 'pointer' => '/data/attributes/name' }, 'status' => 422)
      end
    end

    it 'deletes resource' do
      picture = Picture.create name: 'beautiful'
      http :delete, app_picture_path(picture)
      expect(response.headers['Content-Type']).to include 'application/vnd.api+json'
      json = JSON.parse response.body
      expect(json['data']).to include 'id' => picture.id, 'type' => 'pictures'
      expect(json['data']['attributes']).to include 'id' => picture.id, 'name' => 'beautiful'
      expect(json['links']['self']).to include app_picture_path(picture)
    end
  end

  context 'when it inherits from ResourcesController' do
    it 'lists collection' do
      picture1 = Picture.create name: 'picture1'
      picture2 = Picture.create name: 'picture2'
      picture3 = Picture.create name: 'picture3'
      http :get, resources_pictures_path
      expect(response.headers['Content-Type']).to include 'application/vnd.api+json'
      json = JSON.parse response.body
      expect(json['data'][0]).to include 'id' => picture1.id, 'type' => 'pictures'
      expect(json['data'][0]['attributes']).to include 'id' => picture1.id, 'name' => picture1.name
      expect(json['data'][1]).to include 'id' => picture2.id, 'type' => 'pictures'
      expect(json['data'][1]['attributes']).to include 'id' => picture2.id, 'name' => picture2.name
      expect(json['data'][2]).to include 'id' => picture3.id, 'type' => 'pictures'
      expect(json['data'][2]['attributes']).to include 'id' => picture3.id, 'name' => picture3.name
      expect(json['links']['self']).to include '/resources/pictures'
    end

    it 'shows resource' do
      picture = Picture.create name: 'beautiful'
      http :get, resources_picture_path(picture)
      expect(response.headers['Content-Type']).to include 'application/vnd.api+json'
      json = JSON.parse response.body
      expect(json['data']).to include 'id' => picture.id, 'type' => 'pictures'
      expect(json['data']['attributes']).to include 'id' => picture.id, 'name' => picture.name
      expect(json['links']['self']).to include resources_picture_path(picture)
    end

    it 'creates resource' do
      http :post, resources_pictures_path, params: { picture: { name: 'beautiful' } }
      picture = Picture.last
      expect(response.headers['Content-Type']).to include 'application/vnd.api+json'
      json = JSON.parse response.body
      expect(json['data']).to include 'id' => be_an(Integer), 'type' => 'pictures'
      expect(json['data']['attributes']).to include 'id' => be_an(Integer), 'name' => 'beautiful'
      expect(json['links']['self']).to include resources_picture_path(picture)
    end

    context 'when params is missing for create' do
      it 'shows error' do
        http :post, resources_pictures_path
        expect(response).to have_http_status :bad_request
        expect(response.headers['Content-Type']).to include 'application/vnd.api+json'
        json = JSON.parse response.body
        expect(json['errors']).to include('detail' => a_string_including('param is missing or the value is empty: picture'), 'status' => 400)
      end
    end

    context 'when name is missing for create' do
      it 'shows error' do
        http :post, resources_pictures_path, params: { picture: { test: 'test' } }
        expect(response).to have_http_status :unprocessable_entity
        expect(response.headers['Content-Type']).to include 'application/vnd.api+json'
        json = JSON.parse response.body
        expect(json['errors']).to include('detail' => a_string_including("can't be blank"), 'source' => { 'pointer' => '/data/attributes/name' }, 'status' => 422)
      end
    end

    it 'updates resource' do
      picture = Picture.create name: 'beautiful'
      http :put, resources_picture_path(picture), params: { picture: { name: 'splendid' } }
      expect(response.headers['Content-Type']).to include 'application/vnd.api+json'
      json = JSON.parse response.body
      expect(json['data']).to include 'id' => picture.id, 'type' => 'pictures'
      expect(json['data']['attributes']).to include 'id' => picture.id, 'name' => 'splendid'
      expect(json['links']['self']).to include resources_picture_path(picture)
    end

    context 'when params is missing for update' do
      it 'shows error' do
        picture = Picture.create name: 'beautiful'
        http :put, resources_picture_path(picture)
        expect(response).to have_http_status :bad_request
        expect(response.headers['Content-Type']).to include 'application/vnd.api+json'
        json = JSON.parse response.body
        expect(json['errors']).to include('detail' => a_string_including('param is missing or the value is empty: picture'), 'status' => 400)
      end
    end

    context 'when name is missing for update' do
      it 'shows error' do
        picture = Picture.create name: 'beautiful'
        http :put, resources_picture_path(picture), params: { picture: { name: '' } }
        expect(response).to have_http_status :unprocessable_entity
        expect(response.headers['Content-Type']).to include 'application/vnd.api+json'
        json = JSON.parse response.body
        expect(json['errors']).to include('detail' => a_string_including("can't be blank"), 'source' => { 'pointer' => '/data/attributes/name' }, 'status' => 422)
      end
    end

    it 'deletes resource' do
      picture = Picture.create name: 'beautiful'
      http :delete, resources_picture_path(picture)
      expect(response.headers['Content-Type']).to include 'application/vnd.api+json'
      json = JSON.parse response.body
      expect(json['data']).to include 'id' => picture.id, 'type' => 'pictures'
      expect(json['data']['attributes']).to include 'id' => picture.id, 'name' => 'beautiful'
      expect(json['links']['self']).to include resources_picture_path(picture)
    end
  end

  if Rails::VERSION::MAJOR >= 5
    context 'when it inherits from ActionController::API and includes ResourcesConcern' do
      it 'lists collection' do
        picture1 = Picture.create name: 'picture1'
        picture2 = Picture.create name: 'picture2'
        picture3 = Picture.create name: 'picture3'
        http :get, api_pictures_path
        expect(response.headers['Content-Type']).to include 'application/vnd.api+json'
        json = JSON.parse response.body
        expect(json['data'][0]).to include 'id' => picture1.id, 'type' => 'pictures'
        expect(json['data'][0]['attributes']).to include 'id' => picture1.id, 'name' => picture1.name
        expect(json['data'][1]).to include 'id' => picture2.id, 'type' => 'pictures'
        expect(json['data'][1]['attributes']).to include 'id' => picture2.id, 'name' => picture2.name
        expect(json['data'][2]).to include 'id' => picture3.id, 'type' => 'pictures'
        expect(json['data'][2]['attributes']).to include 'id' => picture3.id, 'name' => picture3.name
        expect(json['links']['self']).to include api_pictures_path
      end

      it 'shows resource' do
        picture = Picture.create name: 'beautiful'
        http :get, app_picture_path(picture)
        expect(response.headers['Content-Type']).to include 'application/vnd.api+json'
        json = JSON.parse response.body
        expect(json['data']).to include 'id' => picture.id, 'type' => 'pictures'
        expect(json['data']['attributes']).to include 'id' => picture.id, 'name' => picture.name
        expect(json['links']['self']).to include app_picture_path(picture)
      end

      it 'creates resource' do
        http :post, api_pictures_path, params: { picture: { name: 'beautiful' } }
        picture = Picture.last
        expect(response.headers['Content-Type']).to include 'application/vnd.api+json'
        json = JSON.parse response.body
        expect(json['data']).to include 'id' => be_an(Integer), 'type' => 'pictures'
        expect(json['data']['attributes']).to include 'id' => be_an(Integer), 'name' => 'beautiful'
        expect(json['links']['self']).to include api_picture_path(picture)
      end

      context 'when params is missing for create' do
        it 'shows error' do
          http :post, api_pictures_path
          expect(response).to have_http_status :bad_request
          expect(response.headers['Content-Type']).to include 'application/vnd.api+json'
          json = JSON.parse response.body
          expect(json['errors']).to include('detail' => a_string_including('param is missing or the value is empty: picture'), 'status' => 400)
        end
      end

      context 'when name is missing for create' do
        it 'shows error' do
          http :post, api_pictures_path, params: { picture: { test: 'test' } }
          expect(response).to have_http_status :unprocessable_entity
          expect(response.headers['Content-Type']).to include 'application/vnd.api+json'
          json = JSON.parse response.body
          expect(json['errors']).to include('detail' => a_string_including("can't be blank"), 'source' => { 'pointer' => '/data/attributes/name' }, 'status' => 422)
        end
      end

      it 'updates resource' do
        picture = Picture.create name: 'beautiful'
        http :put, app_picture_path(picture), params: { picture: { name: 'splendid' } }
        expect(response.headers['Content-Type']).to include 'application/vnd.api+json'
        json = JSON.parse response.body
        expect(json['data']).to include 'id' => picture.id, 'type' => 'pictures'
        expect(json['data']['attributes']).to include 'id' => picture.id, 'name' => 'splendid'
        expect(json['links']['self']).to include app_picture_path(picture)
      end

      context 'when params is missing for update' do
        it 'shows error' do
          picture = Picture.create name: 'beautiful'
          http :put, app_picture_path(picture)
          expect(response).to have_http_status :bad_request
          expect(response.headers['Content-Type']).to include 'application/vnd.api+json'
          json = JSON.parse response.body
          expect(json['errors']).to include('detail' => a_string_including('param is missing or the value is empty: picture'), 'status' => 400)
        end
      end

      context 'when name is missing for update' do
        it 'shows error' do
          picture = Picture.create name: 'beautiful'
          http :put, app_picture_path(picture), params: { picture: { name: '' } }
          expect(response).to have_http_status :unprocessable_entity
          expect(response.headers['Content-Type']).to include 'application/vnd.api+json'
          json = JSON.parse response.body
          expect(json['errors']).to include('detail' => a_string_including("can't be blank"), 'source' => { 'pointer' => '/data/attributes/name' }, 'status' => 422)
        end
      end

      it 'deletes resource' do
        picture = Picture.create name: 'beautiful'
        http :delete, app_picture_path(picture)
        expect(response.headers['Content-Type']).to include 'application/vnd.api+json'
        json = JSON.parse response.body
        expect(json['data']).to include 'id' => picture.id, 'type' => 'pictures'
        expect(json['data']['attributes']).to include 'id' => picture.id, 'name' => 'beautiful'
        expect(json['links']['self']).to include app_picture_path(picture)
      end
    end
  end
end
