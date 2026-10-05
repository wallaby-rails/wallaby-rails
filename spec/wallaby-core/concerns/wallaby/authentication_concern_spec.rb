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
    context 'when the base controller does not provide authentication' do
      let(:base) do
        Class.new do
          def try(method_name, *args)
            respond_to?(method_name) ? public_send(method_name, *args) : nil
          end
        end
      end

      it 'fails closed and raises NotAuthenticated' do
        object = base.new
        object.extend Wallaby::AuthenticationConcern
        expect { object.authenticate_wallaby_user! }.to raise_error Wallaby::NotAuthenticated
      end
    end

    context 'when authenticate_user! is defined and returns truthy' do
      let(:base) do
        Class.new do
          def try(method_name, *args)
            respond_to?(method_name) ? public_send(method_name, *args) : nil
          end

          def authenticate_user!
            true
          end
        end
      end

      it 'returns true' do
        object = base.new
        object.extend Wallaby::AuthenticationConcern
        expect(object.authenticate_wallaby_user!).to be_truthy
      end
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
        def authenticate_wallaby_user!
          true
        end

        def index
          raise Wallaby::Forbidden
        end
      end

      it 'rescues the exception and renders 403' do
        expect { get :index }.not_to raise_error
        expect(response.status).to eq 403
        expect(response).to render_template :error
      end
    end
  end
end
