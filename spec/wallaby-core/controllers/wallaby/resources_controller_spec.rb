# frozen_string_literal: true

require 'rails_helper'

describe Wallaby::ResourcesController, type: :controller do
  describe 'instance methods' do
    let!(:model_class) { Product }

    before do
      controller.params[:resources] = 'products'
    end

    describe '#current_model_decorator' do
      it 'returns model decorator for default model_class' do
        model_decorator = controller.send :current_model_decorator
        expect(model_decorator).to be_a Wallaby::ModelDecorator
        expect(model_decorator.model_class).to eq model_class
        expect(assigns(:current_model_decorator)).to eq model_decorator
      end
    end

    describe '#current_servicer' do
      it 'returns model servicer for default model_class' do
        model_servicer = controller.send :current_servicer
        expect(model_servicer).to be_a Wallaby::ModelServicer
        expect(assigns(:current_servicer)).to eq model_servicer
      end
    end

    describe '#paginate' do
      let(:query) { Product.where(nil) }

      before do
        controller.request.format = :json
      end

      it 'returns the query' do
        paginate = controller.send :paginate, query, paginate: true
        if version? '>= 6'
          expect(paginate.to_sql).to eq 'SELECT "products".* FROM "products" LIMIT 20 OFFSET 0'
        else
          expect(paginate.to_sql).to eq 'SELECT  "products".* FROM "products" LIMIT 20 OFFSET 0'
        end
      end

      context 'when page param is provided' do
        it 'paginate the query' do
          controller.params[:page] = 8
          paginate = controller.send :paginate, query, paginate: true
          if version? '>= 6'
            expect(paginate.to_sql).to eq 'SELECT "products".* FROM "products" LIMIT 20 OFFSET 140'
          else
            expect(paginate.to_sql).to eq 'SELECT  "products".* FROM "products" LIMIT 20 OFFSET 140'
          end
        end
      end

      context 'when per param is provided' do
        it 'paginate the query' do
          controller.params[:per] = 8
          paginate = controller.send :paginate, query, paginate: true
          if version? '>= 6'
            expect(paginate.to_sql).to eq 'SELECT "products".* FROM "products" LIMIT 8 OFFSET 0'
          else
            expect(paginate.to_sql).to eq 'SELECT  "products".* FROM "products" LIMIT 8 OFFSET 0'
          end
        end
      end

      context 'when request format is html' do
        it 'paginate the query' do
          controller.request.format = :html
          paginate = controller.send :paginate, query, paginate: true
          if version? '>= 6'
            expect(paginate.to_sql).to eq 'SELECT "products".* FROM "products" LIMIT 20 OFFSET 0'
          else
            expect(paginate.to_sql).to eq 'SELECT  "products".* FROM "products" LIMIT 20 OFFSET 0'
          end
        end
      end
    end

    describe '#collection' do
      it 'expects call from current_model_decorator' do
        controller.params[:per] = 10
        controller.params[:page] = 2

        collection = controller.send :collection
        expect(assigns(:collection)).to eq collection

        if version? '>= 6'
          expect(collection.to_sql).to eq 'SELECT "products".* FROM "products" LIMIT 10 OFFSET 10'
        else
          expect(collection.to_sql).to eq 'SELECT  "products".* FROM "products" LIMIT 10 OFFSET 10'
        end
      end
    end

    describe '#new_resource' do
      it 'returns new resource' do
        controller.action_name = 'new'
        expect(controller.send(:new_resource)).to be_new_record
      end
    end

    describe '#resource' do
      context 'when resource id is provided' do
        it 'returns the resource' do
          resource = Product.create!(name: 'new Product')
          controller.params[:id] = resource.id
          expect(controller.send(:resource)).to eq resource
        end
      end
    end

    describe '#resource_id' do
      it 'equals params[:id]' do
        controller.params[:id] = 'abc123'
        expect(controller.send(:resource_id)).to eq 'abc123'
      end
    end
  end

  describe 'descendants of Wallaby::ResourcesController' do
    before do
      stub_const('CampervansController', Class.new(described_class))
      stub_const('Campervan', Class.new)
    end

    describe 'CampervansController' do
      describe 'class methods' do
        describe '.model_class' do
          it 'returns model class' do
            expect(CampervansController.model_class).to eq Campervan
          end
        end
      end
    end
  end
end
