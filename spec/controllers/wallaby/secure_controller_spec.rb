require 'rails_helper'

describe Wallaby::SecureController do
  describe '#current_user' do
    it 'returns nil by default' do
      expect(controller.send(:current_user)).to be_nil
    end

    context 'when current_user setting exists' do
      it 'returns a cached current_user' do
        user = { email: 'wallaby@wallaby.org.au' }
        security_config = Wallaby.configuration.security
        security_config.current_user { user }
        controller.send :current_user
        expect(assigns(:current_user)).to eq user
      end
    end

    context 'when current_user setting doesnt exist and super exists' do
      around do |example|
        module SuperCurrentUser
          def current_user
            { email: 'admin@wallaby.org.au' }
          end
        end
        described_class.send :include, SuperCurrentUser
        example.run
        SuperCurrentUser.send :undef_method, :current_user
      end

      it 'returns a cached current_user' do
        security_config = Wallaby.configuration.security
        expect(security_config.current_user?).to be_falsy
        controller.send :current_user
        expect(assigns(:current_user)).to eq(email: 'admin@wallaby.org.au')
      end
    end
  end

  describe '#authenticate_user!' do
    it 'returns true by default' do
      expect(controller.send(:authenticate_user!)).to be_truthy
    end

    context 'when authenticate_user setting exists' do
      it 'returns a cached authenticate_user' do
        security_config = Wallaby.configuration.security
        security_config.authenticate { false }
        expect { controller.send :authenticate_user! }.to raise_error Wallaby::NotAuthenticated
      end
    end

    context 'when authenticate_user setting doesnt exist and super exists' do
      around do |example|
        module SuperAuthenticateUser
          def authenticate_user!
            raise 'custom authentication error'
          end
        end
        described_class.send :include, SuperAuthenticateUser
        example.run
        SuperAuthenticateUser.send :undef_method, :authenticate_user!
      end

      it 'returns a cached authenticate_user' do
        security_config = Wallaby.configuration.security
        expect(security_config.current_user?).to be_falsy
        expect { controller.send :authenticate_user! }.to raise_error 'custom authentication error'
      end
    end
  end
end

describe Wallaby::ResourcesController do
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
