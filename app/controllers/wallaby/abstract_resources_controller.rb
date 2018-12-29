module Wallaby
  # Abstract CRUD controller.
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
    include RailsOverriddenMethods

    self.responder = ResourcesResponder
    respond_to :html
    respond_to :json
    respond_to :csv, only: :index
    helper ResourcesHelper
    before_action :authenticate_user!, except: [:status]

    # @note This is a template method that can be overridden by subclasses
    # Landing page, it does nothing but just rendering home template. This action can be replaced completely:
    #
    # ```
    # def home
    #   generate_dashboard_report
    # end
    # ```
    def home
      # do nothing
    end

    # @note This is a template method that can be overridden by subclasses
    # This is a resourceful action to list records.
    # It is possible to customize this action in sub controller as below:
    #
    # ```
    # def index
    #   # do something before the origin `index` action
    #   super do
    #     # NOTE: index action responds to `html`, `csv` and `json` format
    #     # do something after the origin `index` action, but before responder's rendering
    #   end
    # end
    # ```
    #
    # Otherwise, it can be replaced completely:
    #
    # ```
    # def index
    #   # do something completely different
    #   # NOTE: please ensure that `@collection` is assigned, for instance
    #   @collection = Product.all
    # end
    # ```
    def index
      current_authorizer.authorize :index, current_model_class
      yield if block_given? # after_index
      respond_with collection
    end

    # @note This is a template method that can be overridden by subclasses
    # This is a resourceful action to show the form for creating a record.
    # It is possible to customize this action in sub controller as below:
    #
    # ```
    # def new
    #   # do something before the origin `new` action
    #   super do
    #     # do something after the origin `new` action, but before responder's rendering
    #   end
    # end
    # ```
    #
    # Otherwise, it can be replaced completely:
    #
    # ```
    # def new
    #   # do something completely different
    #   # NOTE: please ensure that `@resource` is assigned, for instance:
    #   @resource = Product.new new_arrival: true
    # end
    # ```
    def new
      current_authorizer.authorize :new, resource
      yield if block_given? # after_new
      respond_with resource
    end

    # @note This is a template method that can be overridden by subclasses
    # This is a resourceful action to create a record.
    # It is possible to customize this action in sub controller as below:
    #
    # ```
    # def create
    #   # do something before the origin `create` action
    #   super do
    #     # do something after the origin `create` action, but before responder's rendering
    #   end
    # end
    # ```
    #
    # Otherwise, it can be replaced completely:
    #
    # ```
    # def create
    #   # do something completely different
    #   # NOTE: please ensure that `@resource` is assigned, for instance:
    #   @resource = Product.new resource_params.merge(new_arrival: true)
    #   @resource.save
    #   respond_with @resource
    # end
    # ```
    # @see Wallaby::ModelServicer#create
    def create
      current_authorizer.authorize :create, resource
      current_servicer.create resource, params
      yield if block_given? # after_create
      respond_with resource, location: helpers.show_path(resource)
    end

    # @note This is a template method that can be overridden by subclasses
    # This is a resourceful action to display the details of a record.
    # It is possible to customize this action in sub controller as below:
    #
    # ```
    # def show
    #   # do something before the origin `show` action
    #   super do
    #     # do something after the origin `show` action, but before responder's rendering
    #   end
    # end
    # ```
    #
    # Otherwise, it can be replaced completely:
    #
    # ```
    # def show
    #   # do something completely different
    #   # NOTE: please ensure that `@resource` is assigned, for instance:
    #   @resource = Product.find_by_slug params[:id]
    # end
    # ```
    def show
      current_authorizer.authorize :show, resource
      yield if block_given? # after_show
      respond_with resource
    end

    # @note This is a template method that can be overridden by subclasses
    # This is a resourceful action to show a form for editing a record.
    # It is possible to customize this action in sub controller as below:
    #
    # ```
    # def edit
    #   # do something before the origin `edit` action
    #   super do
    #     # do something after the origin `edit` action, but before responder's rendering
    #   end
    # end
    # ```
    #
    # Otherwise, it can be replaced completely:
    #
    # ```
    # def edit
    #   # do something completely different
    #   # NOTE: please ensure that `@resource` is assigned, for instance:
    #   @resource = Product.find_by_slug params[:id]
    # end
    # ```
    def edit
      current_authorizer.authorize :edit, resource
      yield if block_given? # after_edit
      respond_with resource
    end

    # @note This is a template method that can be overridden by subclasses
    # This is a resourceful action to update a record.
    # It is possible to customize this action in sub controller as below:
    #
    # ```
    # def update
    #   # do something before the origin `update` action
    #   super do
    #     # do something after the origin `update` action, but before responder's rendering
    #   end
    # end
    # ```
    #
    # Otherwise, it can be replaced completely:
    #
    # ```
    # def update
    #   # do something completely different
    #   # NOTE: please ensure that `@resource` is assigned, for instance:
    #   @resource = Product.find_by_slug params[:id]
    #   @resource.save
    #   respond_with @resource
    # end
    # ```
    # @see Wallaby::ModelServicer#update
    def update
      current_authorizer.authorize :update, resource
      current_servicer.update resource, params
      yield if block_given? # after_update
      respond_with resource, location: helpers.show_path(resource)
    end

    # @note This is a template method that can be overridden by subclasses
    # This is a resourceful action to destroy a record.
    # It is possible to customize this action in sub controller as below:
    #
    # ```
    # def destroy
    #   # do something before the origin `destroy` action
    #   super do
    #     # do something after the origin `destroy` action, but before responder's rendering
    #   end
    # end
    # ```
    #
    # Otherwise, it can be replaced completely:
    #
    # ```
    # def destroy
    #   # do something completely different
    #   # NOTE: please ensure that `@resource` is assigned, for instance:
    #   @resource = Product.find_by_slug params[:id]
    #   @resource.destroy
    #   respond_with @resource
    # end
    # ```
    # @see Wallaby::ModelServicer#destroy
    def destroy
      current_authorizer.authorize :destroy, resource
      current_servicer.destroy resource, params
      yield if block_given? # after_destroy
      respond_with resource, location: helpers.index_path(current_model_class)
    end

    # @note This is a template method that can be overridden by subclasses
    # To whitelist the params for CRUD actions.
    # If Wallaby cannot generate the correct strong parameters, it can be replaced, for instance:
    #
    # ```
    # def resource_params
    #   params.fetch(:product, {}).permit(:name, :sku)
    # end
    # ```
    # @return [ActionController::Parameters] whitelisted params
    # @see Wallaby::ModelServicer#permit
    def resource_params
      @resource_params ||= current_servicer.permit params, action_name
    end
  end
end
