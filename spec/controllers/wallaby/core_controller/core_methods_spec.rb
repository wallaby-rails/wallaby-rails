require 'rails_helper'

describe Wallaby::CoreController::CoreMethods do
  describe Wallaby::CoreController do
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
      let!(:model_class) do
        class FishAndChip < ActiveRecord::Base
          self.table_name = 'products'
        end
        FishAndChip
      end

      before do
        expect(controller).to be_a described_class
        allow(controller).to receive(:params).and_return({ resources: 'fish_and_chips' })
      end

      describe '#resources_name' do
        it 'returns resources name from params' do
          expect(controller.resources_name).to eq 'fish_and_chips'
        end
      end

      describe '#resource_name' do
        it 'returns resource name from params' do
          expect(controller.resource_name).to eq 'fish_and_chip'
        end
      end

      describe '#model_class' do
        context 'when model exists' do
          it 'returns model class for resource' do
            expect(controller.model_class).to eq model_class
          end
        end

        context 'when model is missing' do
          before do
            allow(controller).to receive(:params).and_return({ resources: 'unknown_resources' })
          end

          it 'raises not found' do
            expect{ controller.model_class }.to raise_error Wallaby::ModelNotFound
          end
        end
      end

      describe '#model_decorator' do
        it 'returns model decorator for default model_class' do
          model_decorator = controller.model_decorator
          expect(model_decorator).to be_a Wallaby::ModelDecorator
          expect(model_decorator.model_class).to eq model_class
          expect(assigns :model_decorator).to eq model_decorator
        end

        context 'when model_class is given' do
          it 'returns model decorator for given model_class' do
            model_decorator = controller.model_decorator Product
            expect(model_decorator).to be_a Wallaby::ModelDecorator
            expect(model_decorator.model_class).to eq Product
            expect(assigns :model_decorator).to be_nil
          end
        end
      end

      describe '#resource_decorator' do
        let(:resource_attributes) do
          { name: 'product', sku: 'sku' }
        end
        let(:resource) { model_class.create resource_attributes }
        before do
          allow(controller).to receive(:resource).and_return(resource)
        end

        it 'returns resource decorator for default resource' do
          resource_decorator = controller.resource_decorator
          expect(resource_decorator).to eq Wallaby::ResourceDecorator
          expect(assigns :resource_decorator).to eq resource_decorator
        end

        context 'when resource is given' do
          it 'returns resource decorator for given resource' do
            resource_decorator = controller.resource_decorator Product
            expect(resource_decorator).to eq Wallaby::ResourceDecorator
            expect(assigns :resource_decorator).to be_nil
          end
        end
      end

      describe '#decorate' do
        context 'when it is a collection' do
          it 'returns a collection of decorators' do
            collection = [ model_class.new, model_class.new ]
            decorated = controller.decorate collection
            expect(decorated).to be_a Array
            expect(decorated).to all be_a Wallaby::ResourceDecorator
          end
        end

        context 'when it is a resource' do
          it 'returns a decorator' do
            expect(controller.decorate model_class.new).to be_a Wallaby::ResourceDecorator
          end
        end
      end

      describe '#collection' do
        it 'expects call from model_decorator' do
          expect(controller.model_decorator).to receive(:collection)
          controller.collection
        end
      end

      describe '#resource' do
        it 'expects call from model_decorator' do
          expect(controller.model_decorator).to receive(:find_or_initialize)
          controller.resource
        end
      end

      describe '#resource_id' do
        it 'equals params[:id]' do
          allow(controller).to receive(:params).and_return({ id: 'abc123' })
          expect(controller.resource_id).to eq 'abc123'
        end
      end

      describe '#resource_params' do
        it 'requires form_require_name and form_strong_param_names' do
          allow(controller).to receive(:params).and_return(ActionController::Parameters.new fish_and_chips: { name: 'salmon' }, resources: 'fish_and_chips' )
          expect(controller.model_decorator).to receive(:form_require_name).and_return 'fish_and_chips'
          expect(controller.model_decorator).to receive(:form_strong_param_names).and_return ['name']
          expect(controller.resource_params).to eq({ 'name' =>'salmon' })
        end
      end
    end
  end

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
