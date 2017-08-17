module Wallaby
  # generate query component
  class QueryComponent < BaseComponent
    attr_accessor :model_class

    def initialize(model_class, view)
      @model_class = model_class
      super(view)
    end

    def build(&block)
      div class: query_classes do
        concat query_actions(&block)
        concat query_search
      end
    end

    private

    def query_classes
      classes = %w(query)
      classes.push 'query--filtered' if index_params.present?
      classes
    end

    def query_actions(&block)
      nav class: 'query__actions' do
        concat query_clear if index_params.present?
        concat query_create
        concat query_more
        concat actions_list(&block)
      end
    end

    def query_search
      form_tag index_path, method: :get, class: 'query__search' do
        concat hidden_field_tag :sort, index_params[:sort]
        concat(label_tag(:q) do
          text_field_tag :q, index_params[:q], placeholder: search_hint
        end)
      end
    end

    def query_clear
      index_link(model_class, html_classes('query__clear')) {}
    end

    def query_create
      new_link(model_class, html_classes('query__create')) {}
    end

    def query_more
      a nil, **dropdown_options, class: 'query__more', id: 'actions_list'
    end

    def actions_list
      ul('aria-labelledby' => 'actions_list') do
        concat li export_link
        concat yield
      end
    end

    def export_link
      index_link(model_class, export_params('csv')) { export_title 'CSV' }
    end

    def export_params(format)
      { url_params: index_params.except(:page, :per).merge(format: format) }
    end

    def export_title(format)
      I18n.t 'links.export', ext: format
    end

    def search_hint
      I18n.t 'search.hint'
    end
  end
end
