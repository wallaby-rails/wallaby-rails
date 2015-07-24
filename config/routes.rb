Wallaby::Engine.routes.draw do
  root to: 'wallaby/dashboard#index'
  get 'er_diagram', to: 'wallaby/database#er_diagram'

  get 'status.json', to: 'core#status'

  scope path: ':resources' do
    resources_router = Wallaby::ResourcesRouter.new
    with_options to: resources_router do |route|
      route.match '',
        defaults: { action: :index },   via: :get,    as: :resources
      route.match '',
        defaults: { action: :create },  via: :post
      route.match 'new',
        defaults: { action: :new },     via: :get,    as: :new_resource
      route.match ':id/edit',
        defaults: { action: :edit },    via: :get,    as: :edit_resource
      route.match ':id',
        defaults: { action: :show },    via: :get,    as: :resource
      route.match ':id',
        defaults: { action: :update },  via: %i( patch put )
      route.match ':id',
        defaults: { action: :destroy }, via: :delete
      route.match '(:id)/:action', via: :all
    end
  end
end
