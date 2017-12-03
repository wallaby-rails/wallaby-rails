module Wallaby
  # Generic CRUD controller
  class AbstractResourcesController < ::Wallaby::BaseController
    self.responder = ResourcesResponder
    respond_to :html
    respond_to :json
    respond_to :csv, only: :index
    helper ResourcesHelper

    def self.resources_name
      return unless self < ::Wallaby::ResourcesController
      Map.resources_name_map name.gsub('Controller', EMPTY_STRING)
    end

    def self.model_class
      return unless self < ::Wallaby::ResourcesController
      Map.model_class_map name.gsub('Controller', EMPTY_STRING)
    end

    def home
      # leave blank
    end

    def index
      authorize! :index, current_model_class
      respond_with collection
    end

    def new
      authorize! :new, resource
      yield if block_given? # after_new
      respond_with resource
    end

    def create
      authorize! :create, resource
      current_model_service.create resource, params
      yield if block_given? # after_create
      respond_with resource, location: helpers.show_path(resource)
    end

    def show
      authorize! :show, resource
      yield if block_given? # after_show
      respond_with resource
    end

    def edit
      authorize! :edit, resource
      yield if block_given? # after_edit
      respond_with resource
    end

    def update
      authorize! :update, resource
      current_model_service.update resource, params
      yield if block_given? # after_update
      respond_with resource, location: helpers.show_path(resource)
    end

    def destroy
      authorize! :destroy, resource
      current_model_service.destroy resource, params
      yield if block_given? # after_destroy
      respond_with resource, location: helpers.index_path(current_model_class)
    end

    protected

    def _prefixes
      @_prefixes ||= PrefixesBuilder.new(
        super, controller_path, current_resources_name, params
      ).build
    end

    def lookup_context
      @_lookup_context ||= LookupContextWrapper.new super
    end

    def current_model_service
      @current_model_service ||= begin
        model_class = current_model_class
        Map.servicer_map(model_class).new model_class, authorizer
      end
    end

    def paginate(query)
      if params[:page] || params[:per] || request.format.symbol == :html
        current_model_service.paginate(query, params)
      else
        query
      end
    end

    def resource_params
      @resource_params ||= current_model_service.permit params
    end

    # helper methods
    begin
      helper_method :resource_id, :resource, :collection,
                    :current_model_decorator, :authorizer

      def resource_id
        params[:id]
      end

      def collection
        @collection ||= paginate current_model_service.collection params
      end

      def resource
        @resource ||= if resource_id.present?
                        current_model_service.find resource_id, resource_params
                      else
                        current_model_service.new resource_params
                      end
      end

      def current_model_decorator
        @current_model_decorator ||= helpers.model_decorator current_model_class
      end

      def authorizer
        # TODO: to add support to pundit in the future
        current_ability
      end
    end
  end
end
