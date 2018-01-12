module Wallaby
  # Generic CRUD controller
  class AbstractResourcesController < ::Wallaby::BaseController
    self.responder = ResourcesResponder
    respond_to :html
    respond_to :json
    respond_to :csv, only: :index
    helper ResourcesHelper
    helper_method :resource_id, :resource, :collection,
                  :current_model_decorator, :authorizer

    # Fetch resources name from its class name
    def self.resources_name
      return unless self < ::Wallaby::ResourcesController
      Map.resources_name_map name.gsub('Controller', EMPTY_STRING)
    end

    # Find model class from its resources name
    def self.model_class
      return unless self < ::Wallaby::ResourcesController
      Map.model_class_map resources_name
    end

    # home page
    def home
      # do nothing
    end

    # Index page to list data
    def index
      authorize! :index, current_model_class
      yield if block_given? # after_index
      respond_with collection
    end

    # Form page for creation
    # You could override this method in subclasses in the following ways:
    # - To perform action before `new` is run
    #
    #     ```
    #        def new
    #          # do something beforehand
    #          super
    #        end
    #     ```
    #
    # - To perform action after `new`, but before rendering.
    #  The reason is that we use responder at the end of the action
    #
    #     ```
    #        def new
    #          super do
    #            # do something after new
    #          end
    #        end
    #     ```
    #
    # - To perform completely different action
    #
    #     ```
    #        def new
    #          # do something completely different
    #        end
    #     ```
    def new
      authorize! :new, resource
      yield if block_given? # after_new
      respond_with resource
    end

    # Data creation
    # You could override this method in subclasses in the following ways:
    # - To perform action before `new` is run
    #
    #     ```
    #        def create
    #          # do something beforehand
    #          super
    #        end
    #     ```
    #
    # - To perform action after `create`, but before rendering.
    #  The reason is that we use responder at the end of the action
    #
    #     ```
    #        def create
    #          super do
    #            # do something after create
    #          end
    #        end
    #     ```
    #
    # - To perform completely different action
    #
    #     ```
    #        def create
    #          # do something completely different
    #        end
    #     ```
    def create
      authorize! :create, resource
      current_model_service.create resource, params
      yield if block_given? # after_create
      respond_with resource, location: helpers.show_path(resource)
    end

    # Show page for a single record
    # You could override this method in subclasses in the following ways:
    # - To perform action before `show` is run
    #
    #     ```
    #        def show
    #          # do something beforehand
    #          super
    #        end
    #     ```
    #
    # - To perform action after `show`, but before rendering.
    #  The reason is that we use responder at the end of the action
    #
    #     ```
    #        def show
    #          super do
    #            # do something after show
    #          end
    #        end
    #     ```
    #
    # - To perform completely different action
    #
    #     ```
    #        def show
    #          # do something completely different
    #        end
    #     ```
    def show
      authorize! :show, resource
      yield if block_given? # after_show
      respond_with resource
    end

    # Edit page for a single record
    # You could override this method in subclasses in the following ways:
    # - To perform action before `edit` is run
    #
    #     ```
    #        def edit
    #          # do something beforehand
    #          super
    #        end
    #     ```
    #
    # - To perform action after `edit`, but before rendering.
    #  The reason is that we use responder at the end of the action
    #
    #     ```
    #        def edit
    #          super do
    #            # do something after edit
    #          end
    #        end
    #     ```
    #
    # - To perform completely different action
    #
    #     ```
    #        def edit
    #          # do something completely different
    #        end
    #     ```
    def edit
      authorize! :edit, resource
      yield if block_given? # after_edit
      respond_with resource
    end

    # Date update
    # You could override this method in subclasses in the following ways:
    # - To perform action before `update` is run
    #
    #     ```
    #        def update
    #          # do something beforehand
    #          super
    #        end
    #     ```
    #
    # - To perform action after `update`, but before rendering.
    #  The reason is that we use responder at the end of the action
    #
    #     ```
    #        def update
    #          super do
    #            # do something after update
    #          end
    #        end
    #     ```
    #
    # - To perform completely different action
    #
    #     ```
    #        def update
    #          # do something completely different
    #        end
    #     ```
    def update
      authorize! :update, resource
      current_model_service.update resource, params
      yield if block_given? # after_update
      respond_with resource, location: helpers.show_path(resource)
    end

    # Data deletion
    # You could override this method in subclasses in the following ways:
    # - To perform action before `destroy` is run
    #
    #     ```
    #        def destroy
    #          # do something beforehand
    #          super
    #        end
    #     ```
    #
    # - To perform action after `destroy`, but before rendering.
    #  The reason is that we use responder at the end of the action
    #
    #     ```
    #        def destroy
    #          super do
    #            # do something after destroy
    #          end
    #        end
    #     ```
    #
    # - To perform completely different action
    #
    #     ```
    #        def destroy
    #          # do something completely different
    #        end
    #     ```
    def destroy
      authorize! :destroy, resource
      current_model_service.destroy resource, params
      yield if block_given? # after_destroy
      respond_with resource, location: helpers.index_path(current_model_class)
    end

    protected

    # Override origin ActionView::ViewPaths::ClassMethods#_prefixes
    # to add more paths so that it could look up partials in the following
    # order:
    # - mounted_path/resources_name/action_name (e.g. `admin/products/index)
    # - mounted_path/resources_name (e.g. `admin/products)
    # - full_path_of_custom_resources_controller/action_name
    #  (e.g. `management/custom_products/index)
    # - full_path_of_custom_resources_controller
    #  (e.g. `management/custom_products)
    # - wallaby_resources_controller_name/action_name
    #  (e.g. `wallaby/resources/index)
    # - wallaby_resources_controller_name
    #  (e.g. `wallaby/resources)
    def _prefixes
      @_prefixes ||= PrefixesBuilder.new(
        super, controller_path, current_resources_name, params
      ).build
    end

    # A wrapped lookup content
    # Its aim is to render string partial when given partial is not found
    def lookup_context
      @_lookup_context ||= LookupContextWrapper.new super
    end

    # Current model service to take care of all the CRUD actions
    # For how to override model service, see (Wallaby::ModelServicer)
    def current_model_service
      @current_model_service ||= begin
        model_class = current_model_class
        Map.servicer_map(model_class).new model_class, authorizer
      end
    end

    # To paginate the collection but only when either `page` or `per` param is
    # given, or requesting HTML response
    # @see Wallaby::ModelServicer#paginate
    def paginate(query)
      if params[:page] || params[:per] || request.format.symbol == :html
        current_model_service.paginate(query, params)
      else
        query
      end
    end

    # To whitelist the params for CRUD actions
    # @see Wallaby::ModelServicer#permit
    def resource_params
      @resource_params ||= current_model_service.permit params
    end

    # Shorthand of params[:id]
    def resource_id
      params[:id]
    end

    # @return [#each] a collection of all the records
    def collection
      @collection ||= paginate current_model_service.collection params
    end

    # @return either persisted or unpersisted resource instance
    def resource
      @resource ||=
        if resource_id.present?
          current_model_service.find resource_id, resource_params
        else
          current_model_service.new resource_params
        end
    end

    # Get current model decorator so that we could retrive metadata for given
    # model class.
    def current_model_decorator
      @current_model_decorator ||= helpers.model_decorator current_model_class
    end

    # A wrapper method for authorizer
    # @todo to add support to pundit in the future
    def authorizer
      current_ability
    end
  end
end
