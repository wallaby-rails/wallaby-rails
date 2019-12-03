require 'rails_helper'

describe Wallaby::ResourcesController, type: :controller do
  describe '#current_resources_name' do
    it 'returns resources_name from params' do
      controller.params[:resources] = 'on_sale_products'
      expect(controller.send(:current_resources_name)).to eq 'on_sale_products'
    end
  end

  describe '#current_model_class' do
    it 'returns model class from current_resources_name' do
      controller.params[:resources] = 'products'
      expect(controller.send(:current_model_class)).to eq Product
    end

    context 'when it responds to model_class' do
      CampervansController = Class.new described_class
      Campervan = Class.new ActiveRecord::Base

      describe CampervansController do
        it 'returns model_class from controller class' do
          expect(controller.send(:current_model_class)).to eq Campervan
        end
      end
    end
  end
end
