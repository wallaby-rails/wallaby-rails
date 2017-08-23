module Wallaby
  # pagination metadata component
  class PaginationMetadataComponent < BaseComponent
    attr_reader :paginator, :model_class

    def initialize(paginator, model_class, view)
      @paginator = paginator
      @model_class = model_class
      super(view)
    end

    def build
      span(class: 'pagination__metadata') { metadata }
    end

    private

    def metadata
      if paginator.number_of_pages > 1
        concat pers
        concat of
        concat pages
      else
        from_to + of + total_count
      end
    end

    def pers
      span class: 'pagination__pers' do
        concat a from_to, **dropdown_options, id: 'all_pers'
        concat(ul('aria-labelledby': 'all_pers') do
          concat li em pers_title
          pers_buffer
        end)
      end
    end

    def pages
      span class: 'pagination__pages' do
        concat a total_count, **dropdown_options, id: 'all_pages'
        concat(pages_form do
          render_hidden_params
          concat content_tag :label, pages_title, for: 'page_number'
          concat page_param
        end)
      end
    end

    def pages_form(&block)
      content_tag :form,
                  action: index_path,
                  method: 'get',
                  aria: { labelledby: 'all_pages' }, &block
    end

    def page_param
      number_field_tag 'page', paginator.page_number, id: 'page_number'
    end

    def render_hidden_params
      index_params.except(:page).each do |permitted, value|
        concat hidden_field_tag permitted, value
      end
    end

    def pers_buffer
      PERS.each do |per|
        concat(li(class: active(per)) do
          url_params = index_params.merge per: per
          index_link(model_class, url_params: url_params) { per.to_s }
        end)
      end
    end

    def action_url
      index_path model_class: model_class,
                 url_params: index_params.except(:page)
    end

    def active(per)
      paginator.page_size == per ? 'pagination__pers--current' : EMPTY_STRING
    end

    def from_to
      t 'pagination.from_to', from: paginator.from, to: paginator.to
    end

    def of
      t 'pagination.of'
    end

    def total_count
      t 'pagination.total_count', total: paginator.total
    end

    def pers_title
      t 'pagination.pers'
    end

    def pages_title
      t 'pagination.pages'
    end
  end
end
