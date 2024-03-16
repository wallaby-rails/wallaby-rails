# frozen_string_literal: true

require 'rails_helper'

describe 'overrides the resourceful routes', type: :request do
  let!(:category) { Category.create(name: FFaker::Name.name) }

  it 'renders resourceful actions (e.g. index) ok' do
    http :get, '/admin/categories'
    expect(response).to be_successful
    expect(response).to render_template :index
  end

  it 'renders custom member action' do
    http :get, '/admin/categories/1/member_only'
    expect(response).to be_successful
    expect(response.body).to eq 'This is a member only action for Admin::CategoriesController'
  end

  it 'renders custom collection action' do
    http :get, '/admin/categories/collection_only'
    expect(response).to be_successful
    expect(response.body).to eq 'This is a collection only action for Admin::CategoriesController'
  end

  it 'renders links' do
    http :get, '/admin/categories/links'
    expect(response).to be_successful
    expect(page_json['category']['index']).to include('/admin/categories')
    expect(page_json['category']['new']).to include('/admin/categories/new')
    expect(page_json['category']['show']).to include('/admin/categories/1')
    expect(page_json['category']['edit']).to include('/admin/categories/1/edit')
    expect(page_json['product']['index']).to include('/admin/products')
    expect(page_json['product']['new']).to include('/admin/products/new')
    expect(page_json['product']['show']).to include('/admin/products/1')
    expect(page_json['product']['edit']).to include('/admin/products/1/edit')
  end
end

describe 'add custom resourceful routes', type: :request do
  let!(:category) { Category.create(name: FFaker::Name.name) }

  it 'renders resourceful actions (e.g. index) ok' do
    http :get, '/admin/custom_categories'
    expect(response).to be_successful
    expect(response).to render_template :index
  end

  it 'renders custom member action' do
    http :get, '/admin/custom_categories/1/member_only'
    expect(response).to be_successful
    expect(response.body).to eq 'This is a member only action for Admin::CustomCategoriesController'
  end

  it 'renders custom collection action' do
    http :get, '/admin/custom_categories/collection_only'
    expect(response).to be_successful
    expect(response.body).to eq 'This is a collection only action for Admin::CustomCategoriesController'
  end

  it 'renders links' do
    http :get, '/admin/custom_categories/links'
    expect(response).to be_successful
    expect(page_json['category']['index']).to include('/admin/custom_categories')
    expect(page_json['category']['new']).to include('/admin/custom_categories/new')
    expect(page_json['category']['show']).to include('/admin/custom_categories/1')
    expect(page_json['category']['edit']).to include('/admin/custom_categories/1/edit')
    expect(page_json['product']['index']).to include('/admin/products')
    expect(page_json['product']['new']).to include('/admin/products/new')
    expect(page_json['product']['show']).to include('/admin/products/1')
    expect(page_json['product']['edit']).to include('/admin/products/1/edit')
  end
end
