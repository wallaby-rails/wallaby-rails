require 'rails_helper'

describe Wallaby::SecureController do
  describe 'error handling' do
    describe 'Wallaby::NotAuthenticated' do
      controller do
        def index
          fail Wallaby::NotAuthenticated
        end
      end

      it 'rescues the exception and renders 401' do
        expect{ get :index }.not_to raise_error
        expect(response.status).to eq 401
        expect(response).to render_template 'wallaby/errors/not_authenticated'
      end
    end

    describe 'CanCan::AccessDenied' do
      controller do
        def index
          fail CanCan::AccessDenied
        end
      end

      it 'rescues the exception and renders 401' do
        expect{ get :index }.not_to raise_error
        expect(response.status).to eq 403
        expect(response).to render_template 'wallaby/errors/access_denied'
      end
    end
  end

  describe '#current_user' do
    it 'returns nil by default' do
      expect(controller.send :current_user).to be_nil
    end

    context 'when current_user setting exists' do
      it 'returns a cacheing current_user' do
        user = { email: 'wallaby@wallaby.org.au' }
        security_config = Wallaby::Configuration::Security.new
        security_config.current_user { user }
        allow(controller).to receive(:security_config).and_return(security_config)
        controller.send :current_user
        expect(assigns :current_user).to eq user
      end
    end

    context 'when current_user setting doesnt exist and super exists' do
      before do
        module MockSuper
          def current_user
            { email: 'admin@wallaby.org.au' }
          end
        end
        described_class.send :include, MockSuper
      end

      it 'returns a cacheing current_user' do
        security_config = Wallaby::Configuration::Security.new
        allow(controller).to receive(:security_config).and_return(security_config)
        controller.send :current_user
        expect(assigns :current_user).to eq({ email: 'admin@wallaby.org.au' })
      end
    end
  end

  describe '#authenticate_user!' do
    it 'returns true by default' do
      expect(controller.send :authenticate_user!).to be_truthy
    end

    context 'when authenticate_user setting exists' do
      it 'returns a cacheing authenticate_user' do
        security_config = Wallaby::Configuration::Security.new
        security_config.authenticate { false }
        allow(controller).to receive(:security_config).and_return(security_config)
        expect{ controller.send :authenticate_user! }.to raise_error Wallaby::NotAuthenticated
      end
    end

    context 'when authenticate_user setting doesnt exist and super exists' do
      before do
        module MockSuper
          def authenticate_user!
            fail 'custom authentication error'
          end
        end
        described_class.send :include, MockSuper
      end

      it 'returns a cacheing authenticate_user' do
        security_config = Wallaby::Configuration::Security.new
        allow(controller).to receive(:security_config).and_return(security_config)
        expect{ controller.send :authenticate_user! }.to raise_error 'custom authentication error'
      end
    end
  end
end
