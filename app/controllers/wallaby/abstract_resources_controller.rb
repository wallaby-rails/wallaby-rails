module Wallaby
  # Generic CRUD controller
  class AbstractResourcesController < ::Wallaby::BaseController
    include ConfigurationAttributesAndMethods
    include RailsOverridenMethods
    include ResourcesHelperMethods
    self.responder = ResourcesResponder
    respond_to :html
    respond_to :json
    respond_to :csv, only: :index
    helper ResourcesHelper
    helper_method :resource_id, :resource, :collection,
                  :current_model_decorator, :authorizer

    # Home page
    #
    # You can completely override this action:
    #
    #    def home
    #      # do something differently
    #    end
    def home
      # do nothing
    end

    # Resourceful action to list paginated records.
    #
    # You can override this method in subclasses in the following ways:
    #
    # - To perform action before `index` is run
    #
    #    def index
    #      # do something beforehand
    #      super
    #    end
    #
    # - To perform action after `index`, but before rendering.
    # The reason is that we use responder at the end of the action
    #
    #    def index
    #      super do
    #        # do something afterwards
    #      end
    #    end
    #
    # - To perform completely different action
    #
    #     def index
    #       # do something completely different
    #     end
    def index
      authorize! :index, current_model_class
      yield if block_given? # after_index
      respond_with collection
    end

    # Resourceful new action to show a form for creating a record.
    #
    # You can override this method in subclasses in the following ways:
    #
    # - To perform action before `new` is run
    #
    #    def new
    #      # do something beforehand
    #      super
    #    end
    #
    # - To perform action after `new`, but before rendering.
    # The reason is that we use responder at the end of the action
    #
    #    def new
    #      super do
    #        # do something afterwards
    #      end
    #    end
    #
    # - To perform completely different action
    #
    #     def new
    #       # do something completely different
    #     end
    def new
      authorize! :new, resource
      yield if block_given? # after_new
      respond_with resource
    end

    # Resourceful create action to create a record.
    #
    # You can override this method in subclasses in the following ways:
    #
    # - To perform action before `new` is run
    #
    #     def create
    #       # do something beforehand
    #       super
    #     end
    #
    # - To perform action after `create`, but before rendering.
    # The reason is that we use responder at the end of the action
    #
    #     def create
    #       super do
    #         # do something afterwards
    #       end
    #     end
    #
    # - To perform completely different action
    #
    #     def create
    #       # do something completely different
    #     end
    def create
      authorize! :create, resource
      current_model_service.create resource, params
      yield if block_given? # after_create
      respond_with resource, location: helpers.show_path(resource)
    end

    # Resourceful show action to display values for a record.
    #
    # You can override this method in subclasses in the following ways:
    #
    # - To perform action before `show` is run
    #
    #     def show
    #       # do something beforehand
    #       super
    #     end
    #
    # - To perform action after `show`, but before rendering.
    # The reason is that we use responder at the end of the action
    #
    #     def show
    #       super do
    #         # do something afterwards
    #       end
    #     end
    #
    # - To perform completely different action
    #
    #     def show
    #       # do something completely different
    #     end
    def show
      authorize! :show, resource
      yield if block_given? # after_show
      respond_with resource
    end

    # Resourceful edit action to show a form for editing a record.
    #
    # You can override this method in subclasses in the following ways:
    #
    # - To perform action before `edit` is run
    #
    #     def edit
    #       # do something beforehand
    #       super
    #     end
    #
    # - To perform action after `edit`, but before rendering.
    # The reason is that we use responder at the end of the action
    #
    #     def edit
    #       super do
    #         # do something afterwards
    #       end
    #     end
    #
    # - To perform completely different action
    #
    #     def edit
    #       # do something completely different
    #     end
    def edit
      authorize! :edit, resource
      yield if block_given? # after_edit
      respond_with resource
    end

    # Resourceful update action to update a record.
    #
    # You can override this method in subclasses in the following ways:
    #
    # - To perform action before `update` is run
    #
    #     def update
    #       # do something beforehand
    #       super
    #     end
    #
    # - To perform action after `update`, but before rendering.
    # The reason is that we use responder at the end of the action
    #
    #     def update
    #       super do
    #         # do something afterwards
    #       end
    #     end
    #
    # - To perform completely different action
    #
    #     def update
    #       # do something completely different
    #     end
    def update
      authorize! :update, resource
      current_model_service.update resource, params
      yield if block_given? # after_update
      respond_with resource, location: helpers.show_path(resource)
    end

    # Resourceful destroy action to delete a record.
    #
    # You can override this method in subclasses in the following ways:
    #
    # - To perform action before `destroy` is run
    #
    #     def destroy
    #       # do something beforehand
    #       super
    #     end
    #
    # - To perform action after `destroy`, but before rendering.
    # The reason is that we use responder at the end of the action
    #
    #     def destroy
    #       super do
    #         # do something afterwards
    #       end
    #     end
    #
    # - To perform completely different action
    #
    #     def destroy
    #       # do something completely different
    #     end
    def destroy
      authorize! :destroy, resource
      current_model_service.destroy resource, params
      yield if block_given? # after_destroy
      respond_with resource, location: helpers.index_path(current_model_class)
    end

    # Model servicer associated to current modal class.
    #
    # This model servicer will take care of all the CRUD operations
    #
    # For how to override model service, see (Wallaby::ModelServicer)
    # @return [Wallaby::ModelServicer] a servicer
    def current_model_service
      @current_model_service ||= begin
        model_class = current_model_class
        Map.servicer_map(model_class).new model_class, authorizer
      end
    end

    # To whitelist the params for CRUD actions
    # @see Wallaby::ModelServicer#permit
    # @return [ActionController::Parameters] whitelisted params
    def resource_params
      @resource_params ||= current_model_service.permit params, action_name
    end

    protected

    # To paginate the collection but only when either `page` or `per` param is
    # given, or requesting HTML response
    # @see Wallaby::ModelServicer#paginate
    # @param query [#each]
    # @return [#each]
    def paginate(query)
      paginatable =
        params[:page] || params[:per] || request.format.symbol == :html
      paginatable ? current_model_service.paginate(query, params) : query
    end
  end
end
