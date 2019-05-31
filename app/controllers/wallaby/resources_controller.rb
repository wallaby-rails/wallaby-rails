module Wallaby
  # Resources controller, superclass for all customization controllers.
  # It contains CRUD template action methods (`index`/`new`/`create`/`edit`/`update`/`destroy`)
  # that allow subclasses to override.
  class ResourcesController < ::Wallaby::SecureController
    extend Authorizable::ClassMethods
    extend Baseable::ClassMethods
    extend Decoratable::ClassMethods
    extend Paginatable::ClassMethods
    extend Resourcable::ClassMethods
    extend Servicable::ClassMethods
    extend Themeable::ClassMethods
    include Authorizable
    include Decoratable
    include Defaultable
    include Paginatable
    include RailsOverriddenMethods
    include Resourcable
    include Servicable
    include Themeable

    self.responder = ResourcesResponder
    respond_to :html
    respond_to :json
    respond_to :csv, only: :index
    helper ResourcesHelper
    before_action :authenticate_user!, except: [:status]

    # @note This is a template method that can be overridden by subclasses.
    # This is an action for landing page display. It does nothing more than rendering `home` template.
    #
    # It can be replaced completely in subclasses as below:
    #
    # ```
    # def home
    #   generate_dashboard_report
    # end
    # ```
    def home
      # do nothing
    end

    # @note This is a template method that can be overridden by subclasses.
    # This is a resourceful action to list records that user can access.
    #
    # It can be customized as below in subclasses:
    #
    # `WARN: Please keep in mind that Wallaby User Interface requires **index**
    # action to respond to **csv** and **json** format as well.`
    #
    # ```
    # def index
    #   # do something before the origin action
    #   options = {} # NOTE: see `options` parameter for more details
    #   index!(options) do |format| # NOTE: this is better than using `super`
    #     # NOTE: this block is for `respond_with` which works similar to `respond_to`
    #     # customize response behaviour, or do something before the request is rendered
    #   end
    # end
    # ```
    #
    # Otherwise, it can be replaced completely in subclasses:
    #
    # `WARN: Please keep in mind that Wallaby User Interface requires **index**
    # action to respond to **csv** and **json** format as well.`
    #
    # ```
    # def index
    #   # NOTE: `@collection` will be used by the view, please ensure it is assigned, for example:
    #   @collection = Product.all
    #   respond_with @collection
    # end
    # ```
    # @param options [Hash] (since 5.2.0) options for
    #   {https://www.rubydoc.info/gems/responders/ActionController/RespondWith#respond_with-instance_method
    #   respond_with}
    # @yield [format] block for
    #   {https://www.rubydoc.info/gems/responders/ActionController/RespondWith#respond_with-instance_method
    #   respond_with}
    #   to customize response behaviour.
    # @raise [Wallaby::Forbidden] if user has no access
    def index(options = {}, &block)
      current_authorizer.authorize :index, current_model_class
      respond_with collection, options, &block
    end

    alias index! index

    # @note This is a template method that can be overridden by subclasses.
    # This is a resourceful action to show the form to create record that user is allowed to.
    #
    # It can be customized as below in subclasses:
    #
    # ```
    # def new
    #   # do something before the origin action
    #   options = {} # NOTE: see `options` parameter for more details
    #   new!(options) do |format| # NOTE: this is better than using `super`
    #     # NOTE: this block is for `respond_with` which works similar to `respond_to`
    #     # customize response behaviour, or do something before the request is rendered
    #   end
    # end
    # ```
    #
    # Otherwise, it can be replaced completely in subclasses:
    #
    # ```
    # def new
    #   # NOTE: `@resource` will be used by the view, please ensure it is assigned, for example:
    #   @resource = Product.new new_arrival: true
    # end
    # ```
    # @param options [Hash] (since 5.2.0) options for
    #   {https://www.rubydoc.info/gems/responders/ActionController/RespondWith#respond_with-instance_method
    #   respond_with}
    # @yield [format] block for
    #   {https://www.rubydoc.info/gems/responders/ActionController/RespondWith#respond_with-instance_method
    #   respond_with}
    #   to customize response behaviour.
    # @raise [Wallaby::Forbidden] if user has no access
    def new(options = {}, &block)
      current_authorizer.authorize :new, resource
      respond_with resource, options, &block
    end

    alias new! new

    # @note This is a template method that can be overridden by subclasses.
    # This is a resourceful action to create a record that user is allowed to.
    #
    # If record is created successfully, user will be navigated to the record show page.
    # Otherwise, the form will be shown again with error messages.
    #
    # It can be customized as below in subclasses:
    #
    # ```
    # def create
    #   # do something before the origin action
    #   options = {} # NOTE: see `options` parameter for more details
    #   create!(options) do |format| # NOTE: this is better than using `super`
    #     # NOTE: this block is for `respond_with` which works similar to `respond_to`
    #     # customize response behaviour, or do something before the request is rendered
    #   end
    # end
    # ```
    #
    # Otherwise, it can be replaced completely in subclasses:
    #
    # ```
    # def create
    #   # NOTE: `@resource` will be used by the view, please ensure it is assigned, for example:
    #   @resource = Product.new resource_params.merge(new_arrival: true)
    #   if @resource.save
    #     redirect_to helper.index_path(current_model_class)
    #   else
    #     render :new
    #   end
    # end
    # ```
    # @param options [Hash] (since 5.2.0) options for
    #   {https://www.rubydoc.info/gems/responders/ActionController/RespondWith#respond_with-instance_method
    #   respond_with}. In addition, options `:params` is supported, see below
    # @option options [ActionController::Parameters, Hash] :params
    #   permitted parameters for servicer to create the record. _(defaults to: {#resource_params})_
    # @yield [format] block for
    #   {https://www.rubydoc.info/gems/responders/ActionController/RespondWith#respond_with-instance_method
    #   respond_with}
    #   to customize response behaviour.
    # @raise [Wallaby::Forbidden] if user has no access
    def create(options = {}, &block)
      set_defaults_for :create, options
      current_authorizer.authorize :create, resource
      current_servicer.create resource, options.delete(:params)
      respond_with resource, options, &block
    end

    alias create! create

    # @note This is a template method that can be overridden by subclasses.
    # This is a resourceful action to display the record details that user is allowed to.
    #
    # It can be customized as below in subclasses:
    #
    # ```
    # def show
    #   # do something before the origin action
    #   options = {} # NOTE: see `options` parameter for more details
    #   show!(options) do |format| # NOTE: this is better than using `super`
    #     # NOTE: this block is for `respond_with` which works similar to `respond_to`
    #     # customize response behaviour, or do something before the request is rendered
    #   end
    # end
    # ```
    #
    # Otherwise, it can be replaced completely in subclasses:
    #
    # ```
    # def show
    #   # NOTE: `@resource` will be used by the view, please ensure it is assigned, for example:
    #   @resource = Product.find_by_slug params[:id]
    # end
    # ```
    # @param options [Hash] (since 5.2.0) options for
    #   {https://www.rubydoc.info/gems/responders/ActionController/RespondWith#respond_with-instance_method
    #   respond_with}
    # @yield [format] block for
    #   {https://www.rubydoc.info/gems/responders/ActionController/RespondWith#respond_with-instance_method
    #   respond_with}
    #   to customize response behaviour.
    # @raise [Wallaby::Forbidden] if user has no access
    def show(options = {}, &block)
      current_authorizer.authorize :show, resource
      respond_with resource, options, &block
    end

    alias show! show

    # @note This is a template method that can be overridden by subclasses.
    # This is a resourceful action to show the form to edit record that user is allowed to.
    #
    # It can be customized as below in subclasses:
    #
    # ```
    # def edit
    #   # do something before the origin action
    #   options = {} # NOTE: see `options` parameter for more details
    #   edit!(options) do |format| # NOTE: this is better than using `super`
    #     # NOTE: this block is for `respond_with` which works similar to `respond_to`
    #     # customize response behaviour, or do something before the request is rendered
    #   end
    # end
    # ```
    #
    # Otherwise, it can be replaced completely in subclasses:
    #
    # ```
    # def edit
    #   # NOTE: `@resource` will be used by the view, please ensure it is assigned, for example:
    #   @resource = Product.find_by_slug params[:id]
    # end
    # ```
    # @param options [Hash] (since 5.2.0) options for
    #   {https://www.rubydoc.info/gems/responders/ActionController/RespondWith#respond_with-instance_method
    #   respond_with}
    # @yield [format] block for
    #   {https://www.rubydoc.info/gems/responders/ActionController/RespondWith#respond_with-instance_method
    #   respond_with}
    #   to customize response behaviour.
    # @raise [Wallaby::Forbidden] if user has no access
    def edit(options = {}, &block)
      current_authorizer.authorize :edit, resource
      respond_with resource, options, &block
    end

    alias edit! edit

    # @note This is a template method that can be overridden by subclasses.
    # This is a resourceful action to update the record that user is allowed to.
    #
    # If record is updated successfully, user will be navigated to the record show page.
    # Otherwise, the form will be shown again with error messages.
    #
    # It can be customized as below in subclasses:
    #
    # ```
    # def update
    #   # do something before the origin action
    #   options = {} # NOTE: see `options` parameter for more details
    #   update!(options) do |format| # NOTE: this is better than using `super`
    #     # NOTE: this block is for `respond_with` which works similar to `respond_to`
    #     # customize response behaviour, or do something before the request is rendered
    #   end
    # end
    # ```
    #
    # Otherwise, it can be replaced completely in subclasses:
    #
    # ```
    # def update
    #   # NOTE: `@resource` will be used by the view, please ensure it is assigned, for example:
    #   @resource = Product.find_by_slug params[:id]
    #   @resource.assign_attributes resource_params.merge(new_arrival: true)
    #   if @resource.save
    #     redirect_to helper.index_path(current_model_class)
    #   else
    #     render :new
    #   end
    # end
    # ```
    # @param options [Hash] (since 5.2.0) options for
    #   {https://www.rubydoc.info/gems/responders/ActionController/RespondWith#respond_with-instance_method
    #   respond_with}. In addition, options `:params` is supported, see below
    # @option options [ActionController::Parameters, Hash] :params
    #   permitted parameters for servicer to update the record. _(defaults to: {#resource_params})_
    # @yield [format] block for
    #   {https://www.rubydoc.info/gems/responders/ActionController/RespondWith#respond_with-instance_method
    #   respond_with}
    #   to customize response behaviour.
    # @raise [Wallaby::Forbidden] if user has no access
    def update(options = {}, &block)
      set_defaults_for :update, options
      current_authorizer.authorize :update, resource
      current_servicer.update resource, options.delete(:params)
      respond_with resource, options, &block
    end

    alias update! update

    # @note This is a template method that can be overridden by subclasses.
    # This is a resourceful action to delete the record that user is allowed to.
    #
    # It can be customized as below in subclasses:
    #
    # ```
    # def destroy
    #   # do something before the origin action
    #   options = {} # NOTE: see `options` parameter for more details
    #   destroy!(options) do |format| # NOTE: this is better than using `super`
    #     # NOTE: this block is for `respond_with` which works similar to `respond_to`
    #     # customize response behaviour, or do something before the request is rendered
    #   end
    # end
    # ```
    #
    # Otherwise, it can be replaced completely in subclasses:
    #
    # ```
    # def destroy
    #   # NOTE: `@resource` will be used by the view, please ensure it is assigned, for example:
    #   @resource = Product.find_by_slug params[:id]
    #   @resource.destroy
    #   redirect_to helper.index_path(current_model_class)
    # end
    # ```
    # @param options [Hash] (since 5.2.0) options for
    #   {https://www.rubydoc.info/gems/responders/ActionController/RespondWith#respond_with-instance_method
    #   respond_with}. In addition, options `:params` is supported, see below
    # @option options [ActionController::Parameters, Hash] :params
    #   permitted parameters for servicer to destroy the record. _(defaults to: {#resource_params})_
    # @yield [format] block for
    #   {https://www.rubydoc.info/gems/responders/ActionController/RespondWith#respond_with-instance_method
    #   respond_with}
    #   to customize response behaviour.
    # @raise [Wallaby::Forbidden] if user has no access
    def destroy(options = {}, &block)
      set_defaults_for :destroy, options
      current_authorizer.authorize :destroy, resource
      current_servicer.destroy resource, options.delete(:params)
      respond_with resource, options, &block
    end

    alias destroy! destroy

    # @note This is a template method that can be overridden by subclasses.
    # To whitelist the params for {#create} and {#update} actions.
    #
    # If Wallaby cannot generate the correct strong parameters, it can be replaced, for example:
    #
    # ```
    # def resource_params
    #   params.fetch(:product, {}).permit(:name, :sku)
    # end
    # ```
    # @return [ActionController::Parameters] whitelisted params
    def resource_params
      @resource_params ||= current_servicer.permit params, action_name
    end

    # @!method collection(options = {}, &block)
    #   (see Wallaby::Resourcable#collection)
    #   @see Wallaby::Resourcable#collection
    alias collection! collection

    # @!method resource(options = {}, &block)
    #   (see Wallaby::Resourcable#resource)
    #   @see Wallaby::Resourcable#resource
    alias resource! resource
  end
end
