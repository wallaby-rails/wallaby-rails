module Wallaby
  # Resources controller, superclass for all customization controllers.
  # It contains CRUD template action methods (`index`/`new`/`create`/`edit`/`update`/`destroy`)
  # that allow subclasses to override.
  class ResourcesController < ::Wallaby::AbstractResourcesController
    # @!method home
    #   (see Wallaby::AbstractResourcesController#home)
    #   @see Wallaby::AbstractResourcesController#home

    # @!method index(options = {}, &block)
    #   (see Wallaby::AbstractResourcesController#index)
    #   @see Wallaby::AbstractResourcesController#index

    # @!method new(options = {}, &block)
    #   (see Wallaby::AbstractResourcesController#new)
    #   @see Wallaby::AbstractResourcesController#new

    # @!method create(options = {}, &block)
    #   (see Wallaby::AbstractResourcesController#create)
    #   @see Wallaby::AbstractResourcesController#create

    # @!method show(options = {}, &block)
    #   (see Wallaby::AbstractResourcesController#show)
    #   @see Wallaby::AbstractResourcesController#show

    # @!method edit(options = {}, &block)
    #   (see Wallaby::AbstractResourcesController#edit)
    #   @see Wallaby::AbstractResourcesController#edit

    # @!method update(options = {}, &block)
    #   (see Wallaby::AbstractResourcesController#update)
    #   @see Wallaby::AbstractResourcesController#update

    # @!method destroy(options = {}, &block)
    #   (see Wallaby::AbstractResourcesController#destroy)
    #   @see Wallaby::AbstractResourcesController#destroy

    # @!method resource_params
    #   (see Wallaby::AbstractResourcesController#resource_params)
    #   @see Wallaby::AbstractResourcesController#resource_params

    # @!method collection(options = {}, &block)
    #   (see Wallaby::AbstractResourcesController#collection)
    #   @see Wallaby::AbstractResourcesController#collection

    # @!method resource(options = {}, &block)
    #   (see Wallaby::AbstractResourcesController#resource)
    #   @see Wallaby::AbstractResourcesController#resource

    # @!method current_user
    #   (see Wallaby::SecureController#current_user)
    #   @see Wallaby::SecureController#current_user

    # @!method authenticate_user!
    #   (see Wallaby::SecureController#authenticate_user!)
    #   @see Wallaby::SecureController#authenticate_user!
  end
end
