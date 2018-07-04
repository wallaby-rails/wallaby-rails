Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get '/admin/abc', to: Wallaby::ResourcesRouter.new, as: :abc
  namespace :core do
    mount Wallaby::Engine, at: "/admin", as: :nested_engine
  end
  scope path: '/main' do
    mount Wallaby::Engine, at: "/admin", as: :main_engine
  end
  mount Wallaby::Engine, at: "/admin_else", as: :manager_engine
  mount Wallaby::Engine, at: "/admin"
  mount Wallaby::Engine, at: "/inner", as: :inner_engine, defaults: { resources_controller: InnerController }

  get '/home', to: 'wallaby/resources#home'
  resources :products, controller: 'wallaby/resources', defaults: { resources: 'products' }
  resources :orders
  get '/something/else', to: 'wallaby/resources#index', defaults: { resources: 'products' }

  get '/test/purpose', to: 'application#index'
end
