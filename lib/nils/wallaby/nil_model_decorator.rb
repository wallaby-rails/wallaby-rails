module Wallaby
  # nil model decorator to take care something that can't be handled
  class NilModelDecorator < ModelDecorator
    def fields
      {}
    end

    def index_fields
      {}
    end

    def show_fields
      {}
    end

    def form_fields
      {}
    end

    def form_active_errors(_resource)
      []
    end

    def primary_key
      :id
    end

    def guess_title(resource)
      resource
    end
  end
end
