# frozen_string_literal: true

Wallaby::Engine.routes.draw do
  # NOTE: For health check if needed
  # @see Wallaby::ApplicationConcern#healthy
  get 'status', to: 'wallaby/resources#healthy'

  with_options to: Wallaby::ResourcesRouter.new do
    # @see Wallaby::ResourcesConcern#home
    root defaults: { action: 'home' }

    # Error pages for all supported HTTP status in {Wallaby::ERRORS}
    Wallaby::ERRORS.each do |status|
      code = Rack::Utils::SYMBOL_TO_STATUS_CODE[status]
      get status, defaults: { action: status.to_s }
      get code.to_s, defaults: { action: status.to_s }
    end

    # resourceful routes.
    #
    # `*resources` param here will be converted to the model class
    # used in the controller that [Wallaby::ResourcesRouter] dispatches to.
    # For instance, `"order/items"` will become `Order::Item` later,
    # and `Order::Item` will be used by servicer/authorizer/paginator through out the whole request process.
    #
    # @see Wallaby::ResourcesRouter
    constraints = {
      id: Wallaby::ConstraintRegexp.new(:id_regexp),
      resources: Wallaby::ConstraintRegexp.new(:resources_regexp)
    }

    scope path: '*resources' do
      with_options(constraints: constraints) do
        # NOTE: DO NOT change the order of the following routes!!!
        # @see Wallaby::ResourcesConcern#new
        get 'new', defaults: { action: 'new' }, as: :new_resource
        # @see Wallaby::ResourcesConcern#edit
        get ':id/edit', defaults: { action: 'edit' }, as: :edit_resource
        # @see Wallaby::ResourcesConcern#show
        get ':id', defaults: { action: 'show' }, as: :resource
        # @see Wallaby::ResourcesConcern#update
        match ':id', via: %i[patch put], defaults: { action: 'update' }
        # @see Wallaby::ResourcesConcern#destroy
        delete ':id', defaults: { action: 'destroy' }
        # @see Wallaby::ResourcesConcern#index
        get '', defaults: { action: 'index' }, as: :resources
        # @see Wallaby::ResourcesConcern#create
        post '', defaults: { action: 'create' }
      end
    end
  end
end
