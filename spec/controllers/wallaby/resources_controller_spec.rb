require 'rails_helper'

describe Wallaby::ResourcesController do
  describe 'class methods ' do
    describe '.resources_name' do
      it 'returns nil' do
        expect(described_class.resources_name).to be_nil
      end
    end

    describe '.model_class' do
      it 'returns nil' do
        expect(described_class.model_class).to be_nil
      end
    end
  end

  describe 'instance methods ' do
    let!(:model_class) { Product }

    before do
      allow(controller).to receive(:current_model_class) { model_class }
    end

    describe '#current_model_decorator' do
      it 'returns model decorator for default model_class' do
        model_decorator = controller.send :current_model_decorator
        expect(model_decorator).to be_a Wallaby::ModelDecorator
        expect(model_decorator.model_class).to eq model_class
        expect(assigns :current_model_decorator).to eq model_decorator
      end
    end

    describe '#collection' do
      it 'expects call from current_model_decorator' do
        allow(controller).to receive(:params) { ActionController::Parameters.new per: 10, page: 2 }

        collection = controller.send :collection
        expect(assigns :collection).to eq collection
        expect(collection.to_sql).to eq "SELECT  \"products\".* FROM \"products\" LIMIT 10 OFFSET 10"
      end
    end

    describe '#resource' do
      it 'expects call from current_model_decorator' do
        resource = double 'resource'
        expect(controller.send :current_model_decorator).to receive(:find_or_initialize) { resource }
        controller.send :resource
        expect(assigns :resource).to eq resource
      end
    end

    describe '#resource_id' do
      it 'equals params[:id]' do
        allow(controller).to receive(:params) { ActionController::Parameters.new id: 'abc123' }
        expect(controller.send :resource_id).to eq 'abc123'
      end
    end

    describe '#resource_params' do
      it 'requires form_require_name and form_strong_param_names' do
        allow(controller).to receive(:params) { ActionController::Parameters.new fish_and_chips: { name: 'salmon' }, resources: 'fish_and_chips' }
        current_model_decorator = controller.send :current_model_decorator
        expect(current_model_decorator).to receive(:form_require_name) { 'fish_and_chips' }
        expect(current_model_decorator).to receive(:form_strong_param_names) { ['name'] }
        expect(controller.send :resource_params).to eq({ 'name' =>'salmon' })
      end
    end
  end

  describe 'actions' do
    describe '#index' do
      xit 'renders products'
    end

    describe '#show' do
      xit 'renders product'
    end

    describe '#new' do
      xit 'renders new form'
    end

    describe '#create' do
      xit 'creates the product'
    end

    describe '#edit' do
      xit 'renders edit form'
    end

    describe '#update' do
      xit 'updates the product'
    end
  end

  describe 'subclasses of Wallaby::ResourcesController' do
    let(:subclasses_controller) do
      class CampervansController < Wallaby::ResourcesController; end
      CampervansController
    end

    let!(:model_class) do
      class Campervan < ActiveRecord::Base
        self.table_name = 'products'
      end
      Campervan
    end

    describe 'class methods ' do
      describe '.resources_name' do
        it 'returns resources name from controller name' do
          expect(subclasses_controller.resources_name).to eq 'campervans'
        end
      end

      describe '.model_class' do
        it 'returns model class' do
          expect(subclasses_controller.model_class).to eq model_class
        end
      end
    end
  end
end
