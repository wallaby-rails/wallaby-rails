module Wallaby
  class ResourcesController < CoreController
    include CreateAction, UpdateAction, DestroyAction

    def index
      collection
    end

    def new
      resource
    end

    def create
      if created?
        create_success
      else
        create_error
      end
    end

    def show
      resource
    end

    def edit
      resource
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
  end
end