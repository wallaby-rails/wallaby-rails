require 'rails_helper'

describe 'namespaces', type: :request do
  it 'returns the correct model class for controller' do
    stub_const 'Global::ProductController', (Class.new Wallaby::ResourcesController do
      self.namespace = 'Global'
    end)
    expect(Global::ProductController.model_class).to eq Product
  end

  it 'returns the correct model class for decorator' do
    stub_const 'Global::ProductDecorator', (Class.new Wallaby::ResourceDecorator do
      self.namespace = 'Global'
    end)
    expect(Global::ProductDecorator.model_class).to eq Product
  end

  it 'returns the correct model class for servicer' do
    stub_const 'Global::ProductServicer', (Class.new Wallaby::ModelServicer do
      self.namespace = 'Global'
    end)
    expect(Global::ProductServicer.model_class).to eq Product
  end

  it 'returns the correct model class for authorizer' do
    stub_const 'Global::ProductAuthorizer', (Class.new Wallaby::ModelAuthorizer do
      self.namespace = 'Global'
    end)
    expect(Global::ProductAuthorizer.model_class).to eq Product
  end

  it 'returns the correct model class for paginator' do
    stub_const 'Global::ProductPaginator', (Class.new Wallaby::ModelPaginator do
      self.namespace = 'Global'
    end)
    expect(Global::ProductPaginator.model_class).to eq Product
  end
end
