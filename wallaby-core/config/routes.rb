# frozen_string_literal: true

Wallaby::Engine.routes.draw do
  # NOTE: For health check if needed
  # @see Wallaby::ApplicationConcern#healthy
  get 'status', to: 'wallaby/resources#healthy'

  with_options to: Wallaby::ResourcesRouter.new do |route|
    # @see Wallaby::ResourcesConcern#home
    route.root defaults: { action: 'home' }

    # Error pages for all supported HTTP status in {Wallaby::ERRORS}
    Wallaby::ERRORS.each do |status|
      code = Rack::Utils::SYMBOL_TO_STATUS_CODE[status]
      route.get status, defaults: { action: status.to_s }
      route.get code.to_s, defaults: { action: status.to_s }
    end

    # resourceful routes.
    #
    # `:resources` param here will be converted to the model class in the controller.
    # For instance, `"order::items"` will become `Order::Item` later,
    # and `Order::Item` will be used by servicer/authorizer/paginator through out the whole request process.
    #
    # Using colons in the `:resources` param e.g. `"order::items"` instead of `"order/items"` is
    # to make nested namespace possible to be handled by these dynamic routes.
    # @see Wallaby::ResourcesRouter
    scope path: ':resources' do
      # @see Wallaby::ResourcesConcern#index
      route.get '', defaults: { action: 'index' }, as: :resources
      # @see Wallaby::ResourcesConcern#new
      route.get 'new', defaults: { action: 'new' }, as: :new_resource
      # @see Wallaby::ResourcesConcern#edit
      route.get ':id/edit', defaults: { action: 'edit' }, as: :edit_resource
      # @see Wallaby::ResourcesConcern#show
      route.get ':id', defaults: { action: 'show' }, as: :resource

      # @see Wallaby::ResourcesConcern#create
      route.post '', defaults: { action: 'create' }
      # @see Wallaby::ResourcesConcern#update
      route.match ':id', via: %i[patch put], defaults: { action: 'update' }
      # @see Wallaby::ResourcesConcern#destroy
      route.delete ':id', defaults: { action: 'destroy' }
    end
  end
end
