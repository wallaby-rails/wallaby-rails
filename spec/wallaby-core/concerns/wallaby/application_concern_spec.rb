# frozen_string_literal: true

require 'rails_helper'

describe Wallaby::ResourcesController, type: :controller do
  describe 'configuration shortcuts' do
    describe '#configuration' do
      it { expect(controller.configuration).to be_a Wallaby::Configuration }
    end

    describe '#helpers' do
      it 'works as normal helpers in Rails 5' do
        expect { controller.helpers }.not_to raise_error
        expect(controller.helpers.number_to_currency(1_234_567_890.50)).to eq '$1,234,567,890.50'
        expect(controller.helpers.wt('labels.count')).to eq 'Count: '
      end
    end
  end

  describe '#healthy' do
    it 'returns healthy' do
      get :healthy
      expect(response.body).to eq 'healthy'

      get :healthy, format: :json
      expect(response.body).to eq 'healthy'
    end
  end

  describe 'error handling' do
    describe 'Wallaby::ResourceNotFound' do
      controller do
        def index
          raise Wallaby::ResourceNotFound, 1
        end
      end

      it 'rescues the exception and renders 404' do
        expect { get :index }.not_to raise_error
        expect(response.status).to eq 404
        expect(response).to render_template :error
      end
    end

    describe 'Wallaby::ModelNotFound' do
      controller do
        def index
          raise Wallaby::ModelNotFound, 'Product'
        end
      end

      it 'rescues the exception and renders 404' do
        expect { get :index }.not_to raise_error
        expect(response.status).to eq 404
        expect(response).to render_template :error
      end
    end

    describe 'ActionController::ParameterMissing' do
      controller do
        def index
          params.require(:product)
        end
      end

      it 'rescues the exception and renders 400' do
        expect { get :index }.not_to raise_error
        expect(response.status).to eq 400
        expect(response).to render_template :error
      end
    end

    describe 'ActiveRecord::StatementInvalid' do
      controller do
        def index
          Product.where(unknown: false).to_a
        end
      end

      it 'rescues the exception and renders 422' do
        expect { get :index }.not_to raise_error
        expect(response.status).to eq 422
        expect(response).to render_template :error
      end
    end
  end
end
