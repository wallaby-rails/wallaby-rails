# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get '/admin/abc', to: Wallaby::ResourcesRouter.new, as: :abc
  # all sorts of mounted path to check if wallaby gets confused or not.
  begin
    namespace :core do
      mount Wallaby::Engine, at: '/admin', as: :nested_engine
    end
    scope path: '/main' do
      mount Wallaby::Engine, at: '/admin', as: :main_engine
    end
    mount Wallaby::Engine, at: '/admin_else', as: :manager_engine
    mount Wallaby::Engine, at: '/before_engine', as: :before_engine
    # NOTE this is the part that we should focus
    wallaby_mount at: '/admin' do
      resources :items, path: 'order:\:items', module: :order

      # ordinary categories resources
      resources :categories do
        get :member_only, on: :member
        get :collection_only, on: :collection
        get :links, on: :collection
        get :member_edit, on: :member
        put :member_update, on: :member
        get :collection_list, on: :collection
      end

      # ordinary categories resources
      resources :custom_categories do
        get :member_only, on: :member
        get :collection_only, on: :collection
        get :links, on: :collection
      end

      get 'abc', to: 'categories#index'
    end
    mount Wallaby::Engine, at: '/after_engine', as: :after_engine
    mount Wallaby::Engine, at: '/inner', as: :inner_engine, defaults: { resources_controller: InnerController }

    get '/something/else', to: 'wallaby/resources#index', defaults: { resources: 'products' }
  end

  begin # for non-admin usage
    # testing custom mode purpose
    wresources :postcodes, controller: 'wallaby/resources'
    wresources :zipcodes, controller: 'wallaby/resources'
    wresource :single_resource do
      wresources :multiple_resources
    end
    resource :profile do
      resources :postcodes
    end

    wresource :single_profile, controller: 'wallaby/resources'

    # testing theming purpose
    resources :blogs do
      get :prefixes, on: :collection
    end

    # others
    resources :orders do
      resources :items, module: :order do
        get :prefixes, on: :collection
      end
    end

    resources :categories
    resources :products
    wresources :pictures, controller: 'wallaby/resources'

    scope path: '/before', as: :before do
      resources :products
      resources :pictures
    end

    scope path: '/after', as: :after do
      resources :products
      resources :pictures
    end

    # Tests for JsonApiResponder
    begin
      namespace :app do
        resources :pictures
      end

      namespace :api do
        resources :pictures
      end

      namespace :resources do
        resources :pictures
      end
    end
  end

  begin # for wallaby-view
    namespace :backend, only: [] do
      get 'prefixes', to: 'application#prefixes'

      resource :user, only: [] do
        get 'prefixes'
      end

      resource :user_profile, only: [:show] do
        get 'prefixes'
      end

      resource :custom, only: [] do
        get 'prefixes'
        get 'prefix_options'
      end

      resource :custom_child, only: [] do
        get 'prefixes'
        get 'prefix_options'
      end

      resource :custom_grand_child, only: [] do
        get 'prefixes'
        get 'prefix_options'
      end
    end

    resource :collection, only: [] do
      get 'partials'
    end
  end

  get '/test/purpose', to: 'application#index'
end
