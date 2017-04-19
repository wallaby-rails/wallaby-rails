require 'rails_helper'

describe Wallaby::ApplicationController do
  describe 'error handling' do
    describe 'Wallaby::ResourceNotFound' do
      controller do
        def index
          raise Wallaby::ResourceNotFound, 'Product'
        end
      end

      it 'rescues the exception and renders 404' do
        expect { get :index }.not_to raise_error
        expect(response.status).to eq 404
        expect(response).to render_template 'wallaby/errors/not_found'
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
        expect(response).to render_template 'wallaby/errors/not_found'
      end
    end

    describe 'ActionController::ParameterMissing' do
      controller do
        def index
          params.require(:product)
        end
      end

      it 'rescues the exception and renders 404' do
        expect { get :index }.not_to raise_error
        expect(response.status).to eq 422
        expect(response).to render_template 'wallaby/errors/unprocessable_entity'
      end
    end
  end
end
