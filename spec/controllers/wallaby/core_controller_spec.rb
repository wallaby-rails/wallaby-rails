require 'rails_helper'

describe Wallaby::CoreController do
  describe '#status' do
    it 'returns healthy' do
      get :status
      expect(response.body).to eq 'healthy'

      get :status, format: :json
      expect(response.body).to eq 'healthy'
    end
  end

  describe '#current_resources_name' do
    it 'returns resources_name from params' do
      allow(controller).to receive(:params).and_return({ resources: 'on_sale_products' })
      expect(controller.send :current_resources_name).to eq 'on_sale_products'
    end
  end

  describe '#current_model_class' do
    it 'returns model class from current_resources_name' do
      allow(controller).to receive(:current_resources_name) { 'products' }
      expect(controller.send :current_model_class).to eq Product
    end

    context 'when it responds to model_class' do
      CampervansController = Class.new(Wallaby::ResourcesController) do
        def current_resources_name; 'categories'; end
      end

      Campervan = Class.new(ActiveRecord::Base) do
        self.table_name = 'all_postgres_types'
        attribute :point, :point
      end

      describe CampervansController do
        it 'returns model_class from controller class' do
          expect(controller.send :current_model_class).to eq Campervan
        end
      end

    end
  end
end
