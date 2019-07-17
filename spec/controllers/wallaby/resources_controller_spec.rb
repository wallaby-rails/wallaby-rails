require 'rails_helper'

describe Wallaby::ResourcesController do
  describe '#home' do
    it 'renders home' do
      routes.draw { get 'home' => 'wallaby/resources#home' }
      get :home
      expect(response).to be_successful
      expect(response).to render_template :home
    end
  end

  describe 'CRUD' do
    Wallaby::TestUtils.around_crud(self)

    describe '#index' do
      it 'renders index' do
        all_postgres_type = AllPostgresType.create string: 'something'
        get :index, spec_params(resources: 'all_postgres_type')
        expect(assigns(:collection)).to include all_postgres_type
        expect(response).to be_successful
        expect(response).to render_template :index
      end
    end

    describe '#show' do
      it 'renders show' do
        all_postgres_type = AllPostgresType.create string: 'something'
        get :show, spec_params(resources: 'all_postgres_type', id: all_postgres_type.id)
        expect(assigns(:resource).string).to eq all_postgres_type.string
        expect(response).to be_successful
        expect(response).to render_template :show
      end
    end

    describe '#new' do
      it 'renders new' do
        get :new, spec_params(resources: 'all_postgres_type')
        expect(assigns(:resource)).to be_a AllPostgresType
        expect(response).to be_successful
        expect(response).to render_template :new
      end
    end

    describe '#create' do
      it 'renders create' do
        post :create, spec_params(resources: 'all_postgres_type', all_postgres_type: { string: 'something' })
        all_postgres_type = AllPostgresType.first
        expect(assigns(:resource).string).to eq all_postgres_type.string
        expect(response).to redirect_to a_string_matching "/all_postgres_types/#{all_postgres_type.id}"
      end
    end

    describe '#edit' do
      it 'renders edit' do
        all_postgres_type = AllPostgresType.create string: 'something'
        get :edit, spec_params(resources: 'all_postgres_type', id: all_postgres_type.id)
        expect(assigns(:resource).string).to eq all_postgres_type.string
        expect(response).to be_successful
        expect(response).to render_template :edit
      end
    end

    describe '#update' do
      it 'renders update' do
        all_postgres_type = AllPostgresType.create string: 'something'
        put :update, spec_params(resources: 'all_postgres_type', id: all_postgres_type.id, all_postgres_type: { string: 'something' })
        expect(assigns(:resource).string).to eq all_postgres_type.string
        expect(response).to redirect_to a_string_matching "/all_postgres_types/#{all_postgres_type.id}"
      end
    end

    describe '#destroy' do
      it 'renders destroy' do
        all_postgres_type = AllPostgresType.create string: 'something'
        delete :destroy, spec_params(resources: 'all_postgres_type', id: all_postgres_type.id)
        expect(assigns(:resource).string).to eq all_postgres_type.string
        expect(response).to redirect_to a_string_matching '/all_postgres_types'
      end
    end
  end

  describe 'instance methods ' do
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
        expect(paginate.to_sql).to eq 'SELECT  "products".* FROM "products" LIMIT 20 OFFSET 0'
      end

      context 'when page param is provided' do
        it 'paginate the query' do
          controller.params[:page] = 8
          paginate = controller.send :paginate, query, paginate: true
          expect(paginate.to_sql).to eq 'SELECT  "products".* FROM "products" LIMIT 20 OFFSET 140'
        end
      end

      context 'when per param is provided' do
        it 'paginate the query' do
          controller.params[:per] = 8
          paginate = controller.send :paginate, query, paginate: true
          expect(paginate.to_sql).to eq 'SELECT  "products".* FROM "products" LIMIT 8 OFFSET 0'
        end
      end

      context 'when page param is provided' do
        it 'paginate the query' do
          controller.request.format = :html
          paginate = controller.send :paginate, query, paginate: true
          expect(paginate.to_sql).to eq 'SELECT  "products".* FROM "products" LIMIT 20 OFFSET 0'
        end
      end
    end

    describe '#collection' do
      it 'expects call from current_model_decorator' do
        controller.params[:per] = 10
        controller.params[:page] = 2

        collection = controller.send :collection
        expect(assigns(:collection)).to eq collection
        expect(collection.to_sql).to eq 'SELECT  "products".* FROM "products" LIMIT 10 OFFSET 10'
      end
    end

    describe '#resource' do
      it 'returns new resource' do
        controller.action_name = 'new'
        expect(controller.send(:resource)).to be_new_record
      end

      it 'returns new resource' do
        controller.action_name = 'create'
        expect(controller.send(:resource)).to be_new_record
      end

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

    describe '#_prefixes' do
      module Space
        class PlanetsController < Wallaby::ResourcesController; end
        class Planet; end
      end

      before do
        controller.params[:action] = 'index'
      end

      it 'returns prefixes' do
        controller.params[:resources] = 'wallaby/resources'
        expect(controller.send(:_prefixes)).to eq ['wallaby/resources/index', 'wallaby/resources']
      end

      context 'when current_resources_name is different' do
        it 'returns prefixes' do
          controller.params[:resources] = 'products'
          expect(controller.send(:_prefixes)).to eq ['admin/products/index', 'admin/products', 'wallaby/resources/index', 'wallaby/resources']
        end
      end

      context 'for descendants' do
        describe Space::PlanetsController do
          it 'returns prefixes' do
            controller.params[:resources] = 'space/planets'
            expect(controller.send(:_prefixes)).to eq ['space/planets/index', 'space/planets', 'wallaby/resources/index', 'wallaby/resources']
          end

          context 'when current_resources_name is different' do
            it 'returns prefixes' do
              controller.params[:resources] = 'mars'
              expect(controller.send(:_prefixes)).to eq ['admin/mars/index', 'admin/mars', 'space/planets/index', 'space/planets', 'wallaby/resources/index', 'wallaby/resources']
            end
          end

          context 'when theme name is give' do
            before { Space::PlanetsController.theme_name = 'theme1' }
            after { Space::PlanetsController.theme_name = nil }
            it 'returns prefixes' do
              controller.params[:resources] = 'space/planets'
              expect(controller.send(:_prefixes)).to eq ['space/planets/index', 'space/planets', 'theme1/index', 'theme1', 'wallaby/resources/index', 'wallaby/resources']
            end

            context 'when current_resources_name is different' do
              it 'returns prefixes' do
                controller.params[:resources] = 'mars'
                expect(controller.send(:_prefixes)).to eq ['admin/mars/index', 'admin/mars', 'space/planets/index', 'space/planets', 'theme1/index', 'theme1', 'wallaby/resources/index', 'wallaby/resources']
              end
            end
          end
        end
      end

      %w(new create edit update).each do |action_name|
        context 'action is new' do
          before { controller.params[:action] = action_name }

          it 'returns prefixes' do
            controller.params[:resources] = 'wallaby/resources'
            expect(controller.send(:_prefixes)).to eq ['wallaby/resources/form', 'wallaby/resources']
          end

          context 'when current_resources_name is different' do
            it 'returns prefixes' do
              controller.params[:resources] = 'products'
              expect(controller.send(:_prefixes)).to eq ['admin/products/form', 'admin/products', 'wallaby/resources/form', 'wallaby/resources']
            end
          end

          context 'for descendants' do
            describe Space::PlanetsController do
              it 'returns prefixes' do
                controller.params[:resources] = 'space/planets'
                expect(controller.send(:_prefixes)).to eq ['space/planets/form', 'space/planets', 'wallaby/resources/form', 'wallaby/resources']
              end

              context 'when current_resources_name is different' do
                it 'returns prefixes' do
                  controller.params[:resources] = 'mars'
                  expect(controller.send(:_prefixes)).to eq ['admin/mars/form', 'admin/mars', 'space/planets/form', 'space/planets', 'wallaby/resources/form', 'wallaby/resources']
                end
              end

              context 'when theme name is give' do
                before { Space::PlanetsController.theme_name = 'theme1' }
                after { Space::PlanetsController.theme_name = nil }
                it 'returns prefixes' do
                  controller.params[:resources] = 'space/planets'
                  expect(controller.send(:_prefixes)).to eq ['space/planets/form', 'space/planets', 'theme1/form', 'theme1', 'wallaby/resources/form', 'wallaby/resources']
                end

                context 'when current_resources_name is different' do
                  it 'returns prefixes' do
                    controller.params[:resources] = 'mars'
                    expect(controller.send(:_prefixes)).to eq ['admin/mars/form', 'admin/mars', 'space/planets/form', 'space/planets', 'theme1/form', 'theme1', 'wallaby/resources/form', 'wallaby/resources']
                  end
                end
              end
            end
          end
        end
      end
    end
  end

  describe 'descendants of Wallaby::ResourcesController' do
    class CampervansController < Wallaby::ResourcesController; end
    class Campervan; end

    describe CampervansController do
      describe 'class methods ' do
        describe '.model_class' do
          it 'returns model class' do
            expect(described_class.model_class).to eq Campervan
          end
        end
      end
    end
  end
end
