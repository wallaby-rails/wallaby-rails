module Wallaby
  # Generic CRUD controller
  class AbstractResourcesController < BaseController
    self.responder = ResourcesResponder
    respond_to :html, except: :export
    respond_to :json, only: %i[index show]
    respond_to :csv, only: :export
    helper ResourcesHelper

    def self.resources_name
      return unless self < ::Wallaby::ResourcesController
      Map.resources_name_map name.gsub('Controller', EMPTY_STRING)
    end

    def self.model_class
      return unless self < ::Wallaby::ResourcesController
      Map.model_class_map name.gsub('Controller', EMPTY_STRING)
    end

    def index
      authorize! :index, current_model_class
      respond_with collection
    end

    def new
      authorize! :new, new_resource
    end

    def create
      authorize! :create, current_model_class
      @resource, _is_success = current_model_service.create params
      respond_with resource, location: resources_index_path
    end

    def show
      authorize! :show, resource
      respond_with resource
    end

    def edit
      authorize! :edit, resource
    end

    def update
      authorize! :update, resource
      @resource, _is_success = current_model_service.update resource, params
      respond_with resource, location: resources_show_path
    end

    def destroy
      authorize! :destroy, resource
      is_success = current_model_service.destroy resource, params
      location = -> { is_success ? resources_index_path : resources_show_path }
      respond_with resource, location: location
    end

    def export
      authorize! :index, current_model_class
      respond_with collection
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
      wallaby_engine.resources_path current_resources_name
    end

    def resources_show_path
      wallaby_engine.resource_path current_resources_name, resource_id
    end

    def current_model_service
      @current_model_service ||= helpers.model_servicer current_model_class
    end

    def new_resource
      @resource ||= current_model_service.new params
    end

    def paginate(query)
      return query unless query.respond_to?(:page)
      per = if request.format.symbol == :html || params[:page]
              params[:per] || configuration.page_size
            end
      return query if per.blank?
      query.page(params[:page]).per(per)
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
