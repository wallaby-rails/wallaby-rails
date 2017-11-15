module Wallaby
  # Generic CRUD controller
  class AbstractResourcesController < BaseController
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
      authorize! :new, new_resource
      yield if block_given? # after_new
    end

    def create
      authorize! :create, current_model_class
      @resource, _is_success = current_model_service.create params
      yield if block_given? # after_create
      respond_with resource, location: resources_index_path
    end

    def show
      authorize! :show, resource
      yield if block_given? # after_show
      respond_with resource
    end

    def edit
      authorize! :edit, resource
      yield if block_given? # after_edit
    end

    def update
      authorize! :update, resource
      @resource, _is_success = current_model_service.update resource, params
      yield if block_given? # after_update
      respond_with resource, location: resources_show_path
    end

    def destroy
      authorize! :destroy, resource
      is_success = current_model_service.destroy resource, params
      yield if block_given? # after_destroy
      location = -> { is_success ? resources_index_path : resources_show_path }
      respond_with resource, location: location
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

    def resources_index_path
      helpers.index_path model_class: current_resources_name
    end

    def resources_show_path
      helpers.show_path resource
    end

    def current_model_service
      @current_model_service ||= helpers.model_servicer current_model_class
    end

    def new_resource
      @resource ||= current_model_service.new params
    end

    def paginate(query)
      if params[:page] || params[:per] || request.format.symbol == :html
        current_model_service.paginate(query, params)
      else
        query
      end
    end

    begin # helper methods
      helper_method \
        :resource_id, :resource, :collection, :current_model_decorator

      def resource_id
        params[:id]
      end

      def collection
        @collection ||= paginate current_model_service.collection params
      end

      def resource
        @resource ||= current_model_service.find resource_id, params
      end

      def current_model_decorator
        @current_model_decorator ||= helpers.model_decorator current_model_class
      end
    end
  end
end
