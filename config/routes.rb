Wallaby::Engine.routes.draw do
  # NOTE: For health check if needed
  # @see Wallaby::ApplicationController#healthy
  get 'status', to: 'wallaby/resources#healthy'

  with_options to: Wallaby::ResourcesRouter.new do |route|
    # @see `home` action for more
    route.root defaults: { action: 'home' }

    # To generate error pages for all supported HTTP status
    Wallaby::ERRORS.each do |status|
      code = Rack::Utils::SYMBOL_TO_STATUS_CODE[status]
      route.get status, defaults: { action: status }
      route.get code.to_s, defaults: { action: status }
    end

    # To generate general CRUD resourceful routes
    # @see Wallaby::ResourcesRouter
    scope path: ':resources' do
      # @see Wallaby::ResourcesController#index
      route.get '', defaults: { action: 'index' }, as: :resources
      # @see Wallaby::ResourcesController#new
      route.get 'new', defaults: { action: 'new' }, as: :new_resource
      # @see Wallaby::ResourcesController#edit
      route.get ':id/edit', defaults: { action: 'edit' }, as: :edit_resource
      # @see Wallaby::ResourcesController#show
      route.get ':id', defaults: { action: 'show' }, as: :resource

      # @see Wallaby::ResourcesController#create
      route.post '', defaults: { action: 'create' }
      # @see Wallaby::ResourcesController#update
      route.match ':id', via: %i(patch put), defaults: { action: 'update' }
      # @see Wallaby::ResourcesController#destroy
      route.delete ':id', defaults: { action: 'destroy' }
    end
  end
end
