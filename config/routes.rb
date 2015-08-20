Wallaby::Engine.routes.draw do
  root to: 'wallaby/dashboard#index'
  get 'er_diagram', to: 'wallaby/database#er_diagram'

  get 'status.json', to: 'core#status'

  scope path: ':resources' do
    resources_router      = Wallaby::ResourcesRouter.new
    resources_constraints = Wallaby::ResourcesConstraints.new
    with_options to: resources_router do |route|
      begin # resourceful routes
        route.get '',
          defaults: { action: 'index' },
          as: :resources
        route.get 'new',
          defaults: { action: 'new' },
          as: :new_resource
        route.get ':id/edit',
          defaults: { action: 'edit' },
          as: :edit_resource,
          constraints: resources_constraints
        route.get ':id',
          defaults: { action: 'show' },
          as: :resource,
          constraints: resources_constraints

        route.post '',
          defaults: { action: 'create' }
        route.match ':id',
          via: %i(  patch put ),
          defaults: { action: 'update' },
          constraints: resources_constraints
        route.delete ':id',
          defaults: { action: 'destroy' },
          constraints: resources_constraints
      end
      route.match ':id/:action', via: :all
      route.match ':action', via: :all
    end
  end
end
