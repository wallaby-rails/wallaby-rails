# frozen_string_literal: true

require 'rails_helper'

describe 'Resources pages using postgresql table', type: :request do
  let(:string) { 'Vincent van Gogh' }
  let(:model_class) { AllPostgresType }

  describe '#index' do
    let!(:record) { model_class.create!(string: string) }

    it 'renders collections' do
      http :get, '/admin/all_postgres_types.csv'
      expect(response).to be_successful
      expect(response).to render_template :index
      expect(response.body).to include string
    end

    context 'with sorting' do
      it 'renders collections' do
        http :get, '/admin/all_postgres_types.csv?sort=string%20desc'
        expect(response).to be_successful
        expect(response).to render_template :index
        expect(response.body).to include string
      end
    end

    context 'with keyword' do
      it 'renders collections' do
        http :get, '/admin/all_postgres_types.csv?q=van'
        expect(response).to be_successful
        expect(response).to render_template :index
        expect(response.body).to include string

        http :get, '/admin/all_postgres_types.csv?q=string:~van'
        expect(response).to be_successful
        expect(response).to render_template :index
        expect(response.body).to include string
      end

      context 'when not found' do
        it 'renders collections' do
          http :get, '/admin/all_postgres_types.csv?q=unknown'
          expect(response).to be_successful
          expect(response).to render_template :index
          expect(response.body).not_to include string
        end
      end
    end

    context 'with pagination' do
      it 'renders collections' do
        http :get, '/admin/all_postgres_types.csv?per=100'
        expect(response).to be_successful
        expect(response).to render_template :index
        expect(response.body).to include string

        http :get, '/admin/all_postgres_types.csv?page=1'
        expect(response).to be_successful
        expect(response).to render_template :index
        expect(response.body).to include string
      end

      context 'when not found' do
        it 'renders collections' do
          http :get, '/admin/all_postgres_types.csv?page=100'
          expect(response).to be_successful
          expect(response).to render_template :index
          expect(response.body).not_to include string
        end
      end
    end
  end
end
