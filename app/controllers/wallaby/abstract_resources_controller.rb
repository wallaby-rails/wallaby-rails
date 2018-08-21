module Wallaby
  # Generic CRUD controller.
  class AbstractResourcesController < ::Wallaby::SecureController
    extend Authorizable::ClassMethods
    extend Decoratable::ClassMethods
    extend Paginatable::ClassMethods
    extend Resourcable::ClassMethods
    extend Servicable::ClassMethods
    extend Themeable::ClassMethods
    include Authorizable
    include Decoratable
    include Resourcable
    include Servicable
    include Themeable
    include RailsOverridenMethods

    self.responder = ResourcesResponder
    respond_to :html
    respond_to :json
    respond_to :csv, only: :index
    helper ResourcesHelper
    before_action :authenticate_user!, except: [:status]

    # Landing page, it does nothing but just rendering home template. This action can be replaced completely:
    #
    # ```
    # def home
    #   # generate_dashboard_report
    # end
    # ```
    # @note This is a template method that can be overridden by subclasses
    def home
      # do nothing
    end

    # This is a resourceful action to list records.
    # It is possible to customize this action in sub controller as below:
    #
    # ```
    # def index
    #   # do something before the origin `index` action
    #   super do
    #     # do something after the origin `index` action, but before rendering
    #   end
    # end
    # ```
    #
    # Otherwise, it can be replaced completely:
    #
    # ```
    # def index
    #   # do something completely different
    #   # NOTE: but need to make sure that `@collection` is assigned
    #   # NOTE: and index action can respond to `html`, `csv` and `json`
    # end
    # ```
    # @note This is a template method that can be overridden by subclasses
    def index
      current_authorizer.authorize :index, current_model_class
      yield if block_given? # after_index
      respond_with collection
    end

    # This is a resourceful action to show a form for creating a record.
    # It is possible to customize this action in sub controller as below:
    #
    # ```
    # def new
    #   # do something before the origin `new` action
    #   super do
    #     # do something after the origin `new` action, but before rendering
    #   end
    # end
    # ```
    #
    # Otherwise, it can be replaced completely:
    #
    # ```
    # def new
    #   # do something completely different
    #   # NOTE: but need to make sure that `@resource` is assigned
    # end
    # ```
    # @note This is a template method that can be overridden by subclasses
    def new
      current_authorizer.authorize :new, resource
      yield if block_given? # after_new
      respond_with resource
    end

    # This is a resourceful action to create a record.
    # It is possible to customize this action in sub controller as below:
    #
    # ```
    # def create
    #   # do something before the origin `create` action
    #   super do
    #     # do something after the origin `create` action, but before rendering
    #   end
    # end
    # ```
    #
    # Otherwise, it can be replaced completely:
    #
    # ```
    # def create
    #   # do something completely different
    #   # NOTE: but need to make sure that `@resource` is assigned
    # end
    # ```
    # @note This is a template method that can be overridden by subclasses
    def create
      current_authorizer.authorize :create, resource
      current_servicer.create resource, params
      yield if block_given? # after_create
      respond_with resource, location: helpers.show_path(resource)
    end

    # This is a resourceful action to display the details of a record.
    # It is possible to customize this action in sub controller as below:
    #
    # ```
    # def show
    #   # do something before the origin `show` action
    #   super do
    #     # do something after the origin `show` action, but before rendering
    #   end
    # end
    # ```
    #
    # Otherwise, it can be replaced completely:
    #
    # ```
    # def show
    #   # do something completely different
    #   # NOTE: but need to make sure that `@resource` is assigned
    # end
    # ```
    # @note This is a template method that can be overridden by subclasses
    def show
      current_authorizer.authorize :show, resource
      yield if block_given? # after_show
      respond_with resource
    end

    # This is a resourceful action to show a form for editing a record.
    # It is possible to customize this action in sub controller as below:
    #
    # ```
    # def edit
    #   # do something before the origin `edit` action
    #   super do
    #     # do something after the origin `edit` action, but before rendering
    #   end
    # end
    # ```
    #
    # Otherwise, it can be replaced completely:
    #
    # ```
    # def edit
    #   # do something completely different
    #   # NOTE: but need to make sure that `@resource` is assigned
    # end
    # ```
    # @note This is a template method that can be overridden by subclasses
    def edit
      current_authorizer.authorize :edit, resource
      yield if block_given? # after_edit
      respond_with resource
    end

    # This is a resourceful action to update a record.
    # It is possible to customize this action in sub controller as below:
    #
    # ```
    # def update
    #   # do something before the origin `update` action
    #   super do
    #     # do something after the origin `update` action, but before rendering
    #   end
    # end
    # ```
    #
    # Otherwise, it can be replaced completely:
    #
    # ```
    # def update
    #   # do something completely different
    #   # NOTE: but need to make sure that `@resource` is assigned
    # end
    # ```
    # @note This is a template method that can be overridden by subclasses
    def update
      current_authorizer.authorize :update, resource
      current_servicer.update resource, params
      yield if block_given? # after_update
      respond_with resource, location: helpers.show_path(resource)
    end

    # This is a resourceful action to destroy a record.
    # It is possible to customize this action in sub controller as below:
    #
    # ```
    # def destroy
    #   # do something before the origin `destroy` action
    #   super do
    #     # do something after the origin `destroy` action, but before rendering
    #   end
    # end
    # ```
    #
    # Otherwise, it can be replaced completely:
    #
    # ```
    # def destroy
    #   # do something completely different
    #   # NOTE: but need to make sure that `@resource` is assigned
    # end
    # ```
    # @note This is a template method that can be overridden by subclasses
    def destroy
      current_authorizer.authorize :destroy, resource
      current_servicer.destroy resource, params
      yield if block_given? # after_destroy
      respond_with resource, location: helpers.index_path(current_model_class)
    end

    # To whitelist the params for CRUD actions.
    # If Wallaby cannot generate the correct strong parameters, it can be customized as:
    #
    # ```
    # def resource_params
    #   params.fetch(:product, {}).permit(:name, :sku)
    # end
    # ```
    # @note This is a template method that can be overridden by subclasses
    # @see Wallaby::ModelServicer#permit
    # @return [ActionController::Parameters] whitelisted params
    def resource_params
      @resource_params ||= current_servicer.permit params, action_name
    end
  end
end
