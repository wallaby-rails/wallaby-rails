module Wallaby
  class ResourcesController < CoreController
    include CreateAction, UpdateAction, DestroyAction, HelperMethods

    before_action :build_up_view_paths

    class << self
      def resources_name
        Wallaby::Utils.to_resources_name name.gsub('Controller', '')
      end
    end

    def index
      records
    end

    def new
      new_record
    end

    def create
      if created?
        create_success
      else
        create_error
      end
    end

    def show
      record
    end

    def edit
      record
    end

    def update
      if updated?
        update_success
      else
        update_error
      end
    end

    def destroy
      if destroyed?
        destroy_success
      else
        destroy_error
      end
    end

    def search
      # TODO: for ransack
    end

    def history
      # TODO: for papertrail
    end

    protected
    def build_up_view_paths
      lookup_context.prefixes = PrefixesBuilder.new(self).build
    end
  end
end