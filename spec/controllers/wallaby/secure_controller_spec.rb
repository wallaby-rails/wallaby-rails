require 'rails_helper'

describe Wallaby::SecureController do
  describe 'error handling' do
    context 'Wallaby::NotAuthenticated' do
      controller do
        def index
          fail Wallaby::NotAuthenticated
        end
      end

      it 'rescues the exception and renders 401' do
        expect{ get :index }.not_to raise_error
        expect(response.status).to eq 401
      end

      it 'renders access_denied view' do
        expect(controller).to receive(:render).with('wallaby/errors/access_denied', status: 401, layout: 'wallaby/error')
        get :index
      end
    end
  end

  describe '#current_user' do
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
            raise 'custom authentication error'
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