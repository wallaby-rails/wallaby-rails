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
  mount Wallaby::Engine, at: '/admin'
  mount Wallaby::Engine, at: '/inner', as: :inner_engine, defaults: { resources_controller: InnerController }

  get '/something/else', to: 'wallaby/resources#index', defaults: { resources: 'products' }

  begin # for non-admin usage
    resources :blogs, defaults: { resources: 'blogs' }, only: [:index, :show]
    resources :orders, defaults: { resources: 'orders' } do
      resources :items, defaults: { resources: 'order::items' }
    end
    resources :categories, defaults: { resources: 'categories' }
    resources :products, controller: 'wallaby/resources', path: ':resources', constraints: { resources: 'products' }
    resources :pictures, controller: 'wallaby/resources', path: ':resources', constraints: { resources: 'pictures' }

    scope path: '/nested', as: :nested do
      resources :products, controller: 'wallaby/resources', path: ':resources', constraints: { resources: 'products' }
      resources :pictures, controller: 'wallaby/resources', path: ':resources', constraints: { resources: 'pictures' }
    end

    scope path: '/api', as: :api do
      resources :products, controller: 'json_api', path: ':resources', constraints: { resources: 'products' }
      resources :pictures, controller: 'json_api', path: ':resources', constraints: { resources: 'pictures' }
    end
  end

  get '/test/purpose', to: 'application#index'
end
