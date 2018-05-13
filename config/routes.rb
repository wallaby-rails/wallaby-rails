Wallaby::Engine.routes.draw do
  # NOTE: For health check if needed
  # @see Wallaby::BaseController#healthy
  get 'status', to: 'wallaby/application#healthy'

  with_options to: Wallaby::ResourcesRouter.new do |route|
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
      # @see Wallaby::AbstractResourcesController#index
      route.get '', defaults: { action: 'index' }, as: :resources
      # @see Wallaby::AbstractResourcesController#new
      route.get 'new', defaults: { action: 'new' }, as: :new_resource
      # @see Wallaby::AbstractResourcesController#edit
      route.get ':id/edit', defaults: { action: 'edit' }, as: :edit_resource
      # @see Wallaby::AbstractResourcesController#show
      route.get ':id', defaults: { action: 'show' }, as: :resource

      # @see Wallaby::AbstractResourcesController#create
      route.post '', defaults: { action: 'create' }
      # @see Wallaby::AbstractResourcesController#update
      route.match ':id', via: %i(patch put), defaults: { action: 'update' }
      # @see Wallaby::AbstractResourcesController#destroy
      route.delete ':id', defaults: { action: 'destroy' }
    end
  end
end
