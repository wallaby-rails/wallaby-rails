require 'rails_helper'

describe 'namespaces', type: :request do
  it 'returns the correct model class for controller' do
    stub_const 'Global::ProductController', (Class.new Wallaby::ResourcesController do
    end)
    expect(Global::ProductController.model_class).to eq Product

    stub_const 'Core::Global::ApplicationController', (Class.new Wallaby::ResourcesController do
    end)
    expect(Core::Global::ApplicationController.namespace).to eq 'Core::Global'

    stub_const 'Core::Australia::ProductsController', (Class.new Core::Global::ApplicationController do
    end)
    expect(Core::Australia::ProductsController.namespace).to eq 'Core::Global'
    expect(Core::Australia::ProductsController.model_class).to be_nil

    stub_const 'Core::Global::ProductsController', (Class.new Core::Global::ApplicationController do
    end)
    expect(Core::Global::ProductsController.namespace).to eq 'Core::Global'
    expect(Core::Global::ProductsController.model_class).to eq Product
  end

  it 'returns the correct model class for decorator' do
    stub_const 'Global::ProductDecorator', (Class.new Wallaby::ResourceDecorator do
    end)
    expect(Global::ProductDecorator.model_class).to eq Product
  end

  it 'returns the correct model class for servicer' do
    stub_const 'Global::ProductServicer', (Class.new Wallaby::ModelServicer do
    end)
    expect(Global::ProductServicer.model_class).to eq Product
  end

  it 'returns the correct model class for authorizer' do
    stub_const 'Global::ProductAuthorizer', (Class.new Wallaby::ModelAuthorizer do
    end)
    expect(Global::ProductAuthorizer.model_class).to eq Product
  end

  it 'returns the correct model class for paginator' do
    stub_const 'Global::ProductPaginator', (Class.new Wallaby::ModelPaginator do
    end)
    expect(Global::ProductPaginator.model_class).to eq Product
  end
end
