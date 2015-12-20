require 'rails_helper'

describe Wallaby::ApplicationController do
  describe 'error handling' do
    context 'Wallaby::ResourceNotFound' do
      controller do
        def index
          fail Wallaby::ResourceNotFound.new('Product')
        end
      end

      it 'rescues the exception and renders 404' do
        expect{ get :index }.not_to raise_error
        expect(response.status).to eq 404
      end

      it 'renders not_found view' do
        expect(controller).to receive(:render).with('wallaby/errors/not_found', status: 404)
        get :index
      end
    end
  end

  describe '#lookup_context' do
    it 'returns a cacheing lookup_context' do
      expect(controller.lookup_context).to be_a Wallaby::LookupContextWrapper
      expect(controller.instance_variable_get :@_lookup_context).to be_a Wallaby::LookupContextWrapper
    end
  end

  describe '_prefixes' do
    it 'returns a new _prefixes' do
      allow(controller).to receive(:params).and_return({ action: 'index' })
      expect(controller._prefixes).to eq ["wallaby/application/index", "wallaby/application", ""]
    end
  end
end