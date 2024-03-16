# frozen_string_literal: true

require 'rails_helper'

describe 'custom models', type: :request do
  describe 'zipcode' do
    let(:id) { '1' }

    before do
      Wallaby.configuration.custom_models = ['Zipcode']
    end

    it 'renders the not_implemented for index' do
      http :get, zipcodes_path
      expect(response).to have_http_status :not_implemented
    end

    it 'renders the not_implemented for new' do
      http :get, new_zipcode_path
      expect(response).to have_http_status :not_implemented
    end

    it 'renders the not_implemented for show' do
      http :get, zipcode_path(id: id)
      expect(response).to have_http_status :not_implemented
    end

    it 'renders the not_implemented for edit' do
      http :get, edit_zipcode_path(id: id)
      expect(response).to have_http_status :not_implemented
    end

    it 'renders the not_implemented for create' do
      http :post, zipcodes_path
      expect(response).to have_http_status :not_implemented
    end

    it 'renders the not_implemented for update' do
      http :put, zipcode_path(id: id)
      expect(response).to have_http_status :not_implemented
    end

    it 'renders the not_implemented for destroy' do
      http :delete, zipcode_path(id: id)
      expect(response).to have_http_status :not_implemented
    end
  end

  describe 'resourcesful postcode' do
    let(:id) { '4478' }

    before do
      Postcode.cache_store.clear
      Wallaby.configuration.custom_models = ['Postcode']
    end

    it 'renders index page' do
      http :get, postcodes_path
      expect(response).to be_successful
      expect(response.body).to include id
    end

    it 'renders new page' do
      http :get, new_postcode_path
      expect(response).to be_successful
    end

    it 'renders show page' do
      http :get, postcode_path(id: id)
      expect(response).to be_successful
      expect(response.body).to include '2000'
      expect(response.body).to include 'DARLING HARBOUR'
    end

    it 'renders edit page' do
      http :get, edit_postcode_path(id: id)
      expect(response).to be_successful
      expect(response.body).to include '2000'
      expect(response.body).to include 'DARLING HARBOUR'
    end

    it 'creates a postcode record' do
      http :post, postcodes_path, params: {
        postcode: {
          locality: 'New wonder land',
          postcode: '0000'
        }
      }

      http :get, response.redirect_url
      expect(response).to be_successful
      expect(response.body).to include '0000'
      expect(response.body).to include 'New wonder land'
    end

    it 'updates a postcode record' do
      http :put, postcode_path(id: id), params: {
        postcode: { locality: 'Somewhere' }
      }

      http :get, response.redirect_url
      expect(response).to be_successful
      expect(response.body).to include 'Somewhere'
    end

    it 'deletes a postcode record' do
      http :delete, postcode_path(id: id)

      http :get, response.redirect_url
      expect(response).to be_successful
      expect(response.body).not_to include id
      expect(response.body).not_to include 'DARLING HARBOUR'
    end
  end

  describe 'resourceful single profile' do
    let(:id) { '4478' }

    before do
      SingleProfile.cache_store.clear
      Wallaby.configuration.custom_models = ['SingleProfile']
    end

    it 'renders new page' do
      http :get, new_single_profile_path
      expect(response).to be_successful
    end

    it 'renders show page' do
      http :get, single_profile_path
      expect(response).to be_successful
    end

    context 'when profile exists' do
      it 'renders show page' do
        SingleProfile.save SingleProfile.new(first_name: 'Tian', last: 'Chen')
        http :get, single_profile_path
        expect(response).to be_successful
        expect(response.body).to include 'Tian'
      end
    end

    it 'renders edit page' do
      SingleProfile.save SingleProfile.new(first_name: 'Tian', last: 'Chen')
      http :get, edit_single_profile_path
      expect(response).to be_successful
      expect(response.body).to include 'Tian'
    end

    it 'creates a profile record' do
      http :post, single_profile_path, params: {
        single_profile: {
          first_name: 'Tian',
          last: 'Chen'
        }
      }

      expect(response.redirect_url).to include 'http://www.example.com/single_profile'
      http :get, response.redirect_url
      expect(response).to be_successful
      expect(response.body).to include 'Tian'
      expect(response.body).to include 'Chen'
    end

    it 'updates a profile record' do
      SingleProfile.save SingleProfile.new(first_name: 'Tian', last: 'Chen')
      http :put, single_profile_path, params: {
        single_profile: { first_name: 'Somewhere' }
      }

      expect(response.redirect_url).to eq 'http://www.example.com/single_profile'
      http :get, response.redirect_url
      expect(response).to be_successful
      expect(response.body).to include 'Somewhere'
    end

    it 'deletes a profile record' do
      SingleProfile.save SingleProfile.new(first_name: 'Tian', last: 'Chen')

      http :delete, single_profile_path

      expect(response.redirect_url).to eq 'http://www.example.com/single_profile'
      http :get, response.redirect_url
      expect(response).to be_successful
      expect(SingleProfile.find).to be_blank
    end
  end
end
