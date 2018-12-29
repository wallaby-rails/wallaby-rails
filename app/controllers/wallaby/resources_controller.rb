module Wallaby
  # Resources controller, superclass for all customization controllers.
  # It contains CRUD template action methods (`index`/`new`/`create`/`edit`/`update`/`destroy`)
  # that allow subclasses to override.
  class ResourcesController < ::Wallaby::AbstractResourcesController
    # @!method home
    # @note This is a template method that can be overridden by subclasses
    # @see Wallaby::AbstractResourcesController#home

    # @!method index
    # @note This is a template method that can be overridden by subclasses
    # @see Wallaby::AbstractResourcesController#index

    # @!method new
    # @note This is a template method that can be overridden by subclasses
    # @see Wallaby::AbstractResourcesController#new

    # @!method create
    # @note This is a template method that can be overridden by subclasses
    # @see Wallaby::AbstractResourcesController#create

    # @!method show
    # @note This is a template method that can be overridden by subclasses
    # @see Wallaby::AbstractResourcesController#show

    # @!method edit
    # @note This is a template method that can be overridden by subclasses
    # @see Wallaby::AbstractResourcesController#edit

    # @!method update
    # @note This is a template method that can be overridden by subclasses
    # @see Wallaby::AbstractResourcesController#update

    # @!method destroy
    # @note This is a template method that can be overridden by subclasses
    # @see Wallaby::AbstractResourcesController#destroy

    # @!method resource_params
    # @note This is a template method that can be overridden by subclasses
    # @see Wallaby::AbstractResourcesController#resource_params

    # @!method current_user
    # @note This is a template method that can be overridden by subclasses
    # @see Wallaby::SecureController#current_user

    # @!method authenticate_user!
    # @note This is a template method that can be overridden by subclasses
    # @see Wallaby::SecureController#authenticate_user!
  end
end
