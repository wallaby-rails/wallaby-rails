Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get '/admin/abc', to: Wallaby::ResourcesRouter.new, as: :abc
  namespace :core do
    mount Wallaby::Engine, at: '/admin', as: :nested_engine
  end
  scope path: '/main' do
    mount Wallaby::Engine, at: '/admin', as: :main_engine
  end
  mount Wallaby::Engine, at: '/admin_else', as: :manager_engine
  mount Wallaby::Engine, at: '/before_engine', as: :before_engine
  mount Wallaby::Engine, at: '/admin'
  mount Wallaby::Engine, at: '/after_engine', as: :after_engine
  mount Wallaby::Engine, at: '/inner', as: :inner_engine, defaults: { resources_controller: InnerController }

  get '/something/else', to: 'wallaby/resources#index', defaults: { resources: 'products' }

  begin # for non-admin usage
    # testing custom mode purpose
    wresources :postcodes, controller: 'wallaby/resources'
    wresources :zipcodes, controller: 'wallaby/resources'
    wresource :profile, controller: 'wallaby/resources' do
      wresources :postcodes, controller: 'wallaby/resources'
    end

    # testing theming purpose
    wresources :blogs

    # others
    resources :orders, defaults: { resources: 'orders' } do
      resources :items, defaults: { resources: 'order::items' }
    end

    wresources :categories
    wresources :products, controller: 'wallaby/resources'
    wresources :pictures, controller: 'wallaby/resources'

    scope path: '/before', as: :before do
      wresources :products, controller: 'wallaby/resources'
      wresources :pictures, controller: 'wallaby/resources'
    end

    scope path: '/after', as: :after do
      wresources :products, controller: 'wallaby/resources'
      wresources :pictures, controller: 'wallaby/resources'
    end

    scope path: '/api', as: :api do
      wresources :products, controller: 'json_api'
      wresources :pictures, controller: 'json_api'
    end
  end

  get '/test/purpose', to: 'application#index'
end
