Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  mount Wallaby::Engine, at: "/admin"
  mount Wallaby::Engine, at: "/admin_else", as: :manager_engine
  get '/home', to: 'wallaby/resources#home'
  get '/test/purpose', to: 'application#index'
  resources :products, controller: 'wallaby/resources', defaults: { resources: 'products' }
  get '/something/else', to: 'wallaby/resources#index', defaults: { resources: 'products' }
end
