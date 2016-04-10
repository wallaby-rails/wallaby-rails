module Wallaby
  class ResourcesController < CoreController
    def self.resources_name
      if self < Wallaby::ResourcesController
        Wallaby::Utils.to_resources_name name.gsub('Controller', '')
      end
    end

    def self.model_class
      if self < Wallaby::ResourcesController
        Wallaby::Utils.to_model_class name.gsub('Controller', '')
      end
    end

    def index
      authorize! :index, current_model_class
      collection
    end

    def new
      authorize! :new, new_resource
    end

    def create
      authorize! :create, current_model_class
      @resource, is_success = current_model_service.create params, current_ability
      if is_success
        redirect_to resources_index_path, notice: 'successfully created'
      else
        flash.now[:error] = 'failed to create'
        render :new
      end
    end

    def show
      authorize! :show, resource
    end

    def edit
      authorize! :edit, resource
    end

    def update
      authorize! :update, resource
      @resource, is_success = current_model_service.update resource, params, current_ability
      if is_success
        redirect_to resources_show_path, notice: 'successfully updated'
      else
        flash.now[:error] = 'failed to update'
        render :edit
      end
    end

    def destroy
      authorize! :destroy, resource
      if current_model_service.destroy resource, params
        redirect_to resources_index_path, notice: 'successfully destroyed'
      else
        redirect_to resources_show_path, error: 'failed to destroy'
      end
    end

    protected
    def _prefixes
      @_prefixes ||= begin
        resources_prefix  = current_resources_name.gsub '::', '/'
        wallaby_path      = Wallaby::ResourcesController.controller_path
        suffix            = { 'new' => 'form', 'edit' => 'form' }[params[:action]] || params[:action]

        minimal_prefixes  = super[0..super.index(wallaby_path)]
        unless minimal_prefixes.index resources_prefix
          minimal_prefixes.unshift resources_prefix
        end

        minimal_prefixes.map do |prefix|
          [ "#{ prefix }/#{ suffix }", prefix ]
        end.flatten
      end
    end

    def lookup_context
      @_lookup_context ||= Wallaby::LookupContextWrapper.new super
    end

    def resources_index_path(name = current_resources_name)
      wallaby_engine.resources_path name
    end

    def resources_show_path(name = current_resources_name, id = resource_id)
      wallaby_engine.resource_path name, id
    end

    def current_model_service
      @current_model_service ||= Wallaby::ServicerFinder.find(current_model_class).new current_model_class, current_model_decorator
    end

    def new_resource
      @resource ||= current_model_service.new params
    end

    begin # helper methods
      helper_method :resource_id, :resource, :collection, :current_model_decorator

      def resource_id
        params[:id]
      end

      def collection
        @collection ||= begin
          page_number = params.delete :page
          per_number  = params.delete(:per) || 50

          query = current_model_service.collection params, current_ability
          query = query.page page_number if query.respond_to? :page
          query = query.per per_number if query.respond_to? :per
          query
        end
      end

      def resource
        @resource ||= current_model_service.find resource_id, params
      end

      def current_model_decorator
        @current_model_decorator ||= Wallaby::DecoratorFinder.find_model current_model_class
      end
    end
  end
end
