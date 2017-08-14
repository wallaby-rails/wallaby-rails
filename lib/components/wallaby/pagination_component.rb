module Wallaby
  # pagination component
  class PaginationComponent < BaseComponent
    attr_reader :collection, :model_class

    def initialize(collection, model_class, view)
      @collection = collection
      @model_class = model_class
      super(view)
    end

    def build
      return unless paginator.paginatable?

      nav class: 'pagination' do
        concat metadata_component
        concat prev_page
        concat next_page
      end
    end

    private

    def paginator
      @paginator ||=
        Map.paginator_map(model_class).new model_class, collection, index_params
    end

    def prev_page
      return unless paginator.prev_page?
      span class: 'pagination__prev' do
        url_params = index_params.merge page: paginator.prev_page_number
        index_link(model_class, url_params: url_params) { prev_text }
      end
    end

    def next_page
      return unless paginator.next_page?
      span class: 'pagination__next' do
        url_params = index_params.merge page: paginator.next_page_number
        index_link(model_class, url_params: url_params) { next_text }
      end
    end

    def metadata_component
      PaginationMetadataComponent.new(paginator, model_class, view).build
    end

    def prev_text
      I18n.t 'pagination.prev'
    end

    def next_text
      I18n.t 'pagination.next'
    end
  end
end
