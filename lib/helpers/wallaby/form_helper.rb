module Wallaby
  # Form helper
  module FormHelper
    # @param options [Hash, String]
    # @param locals [Hash] local variables for the partial
    def form_type_partial_render(options = {}, locals = {}, &block)
      PartialRenderer.render_form self, options, locals, &block
    end

    # To generate remote url for auto select plugin.
    # @see app/assets/javascripts/wallaby/auto_select.js
    # @param url [String, nil]
    #   if url is nil, it will fall back to default remote url
    # @param model_class [Class]
    # @param wildcard [String] wildcard that auto_select uses to replace with
    #   the typed keyword
    def remote_url(url, model_class, wildcard = 'QUERY')
      url ||
        index_path(
          model_class, url_params: {
            q: wildcard, per: Wallaby.configuration.pagination.page_size
          }
        )
    end

    # To generate dropdown options (class => url) for polymorphic class.
    # @see app/assets/javascripts/wallaby/auto_select.js
    # This function will pull out remote urls from `metadata[:remote_urls]`
    # (Class => url).
    # @param metadata [Hash]
    # @param wildcard [String]
    # @param select_options [Hash]
    # @return [String] HTML
    def polymorphic_options(metadata, wildcard = 'QUERY', select_options = {})
      urls = metadata[:remote_urls] || {}
      options = (metadata[:polymorphic_list] || []).map do |klass|
        [
          klass, klass,
          { data: { url: remote_url(urls[klass], klass, wildcard) } }
        ]
      end
      options_for_select options, select_options
    end
  end
end
