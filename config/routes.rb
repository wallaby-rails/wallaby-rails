Wallaby::Engine.routes.draw do
  admin_controller_path =
    Wallaby.configuration.mapping.resources_controller.controller_path
  root to: "#{admin_controller_path}#home"

  # NOTE: For health check if needed
  # @see Wallaby::BaseController#healthy
  get 'status', to: "#{admin_controller_path}#healthy"

  # To generate error pages for all HTTP status
  Wallaby::ERRORS.each do |status|
    code = Rack::Utils::SYMBOL_TO_STATUS_CODE[status]
    get status, to: "#{admin_controller_path}##{status}"
    get code.to_s, to: "#{admin_controller_path}##{status}"
  end

  # This is to pass :resources and :action params onto
  # `Wallaby::ResourcesRouter`.
  # So that it could handle the request dispatching.
  # Currently, it has implemented general CRUD resourceful routes
  scope path: ':resources' do
    with_options to: Wallaby::ResourcesRouter.new do |route|
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
