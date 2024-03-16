# frozen_string_literal: true

require 'rails_helper'

describe Wallaby::ResourcesController, type: :controller do
  describe '#wallaby_user' do
    it 'returns nil by default' do
      expect(controller.send(:wallaby_user)).to be_nil
    end

    context 'when wallaby_user defined' do
      controller do
        def wallaby_user
          { email: 'wallaby@wallaby-rails.org.au' }
        end
      end

      it 'calls the defined method' do
        expect(controller.send(:wallaby_user)).to eq email: 'wallaby@wallaby-rails.org.au'
      end
    end
  end

  describe '#authenticate_wallaby_user!' do
    it 'returns true by default' do
      expect(controller.send(:authenticate_wallaby_user!)).to be_truthy
    end

    context 'when authenticate_wallaby_user! defined' do
      controller do
        def authenticate_wallaby_user!
          raise Wallaby::NotAuthenticated
        end
      end

      it 'calls the defined method' do
        expect { controller.send :authenticate_wallaby_user! }.to raise_error Wallaby::NotAuthenticated
      end
    end
  end

  describe 'error handling' do
    describe 'Wallaby::NotAuthenticated' do
      controller do
        def index
          raise Wallaby::NotAuthenticated
        end
      end

      it 'rescues the exception and renders 401' do
        expect { get :index }.not_to raise_error
        expect(response.status).to eq 401
        expect(response).to render_template :error
      end
    end

    describe 'Forbidden' do
      controller do
        def index
          raise Wallaby::Forbidden
        end
      end

      it 'rescues the exception and renders 401' do
        expect { get :index }.not_to raise_error
        expect(response.status).to eq 403
        expect(response).to render_template :error
      end
    end
  end
end
