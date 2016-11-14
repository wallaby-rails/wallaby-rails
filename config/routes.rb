Wallaby::Engine.routes.draw do
  root to: 'wallaby/core#home'

  get 'status', to: 'wallaby/core#status'

  scope path: ':resources' do
    with_options to: Wallaby::ResourcesRouter.new do |route|
      begin # resourceful routes
        route.get '',
          defaults: { action: 'index' },
          as: :resources
        route.get 'new',
          defaults: { action: 'new' },
          as: :new_resource
        route.get ':id/edit',
          defaults: { action: 'edit' },
          as: :edit_resource
        route.get ':id',
          defaults: { action: 'show' },
          as: :resource

        route.post '',
          defaults: { action: 'create' }
        route.match ':id',
          via: %i(  patch put ),
          defaults: { action: 'update' }
        route.delete ':id',
          defaults: { action: 'destroy' }
      end
    end
  end
end
