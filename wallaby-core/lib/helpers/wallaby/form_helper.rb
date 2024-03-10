# frozen_string_literal: true

module Wallaby
  # Form helper
  module FormHelper
    # To generate remote URL for auto select plugin.
    # @see https://github.com/reinteractive/wallaby/blob/master/app/assets/javascripts/wallaby/auto_select.js
    #   auto_select.js
    # @param url [String, nil]
    #   if URL is nil, it will fall back to default remote URL
    # @param model_class [Class]
    # @param wildcard [String] wildcard that auto_select uses to replace with
    #   the typed keyword
    # @return [String] URL for autocomplete
    def remote_url(url, model_class, wildcard = 'QUERY')
      url || index_path(model_class, url_params: { q: wildcard, per: wallaby_controller.try(:page_size) })
    end

    # To generate dropdown options (class => url) for polymorphic class.
    # @see https://github.com/reinteractive/wallaby/blob/master/app/assets/javascripts/wallaby/auto_select.js
    #   auto_select.js
    # This function will pull out remote URLs from `metadata[:remote_urls]`
    # (Class => url).
    # @see ActionView::Helpers::FormOptionsHelper#options_for_select
    # @param metadata [Hash]
    # @param wildcard [String] wildcard to be used in the URL
    # @param select_options [Hash]
    # @return [String] options HTML
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

    # To fetch the hints from the following keys:
    # - hints.#\{ type \}_html
    # - hints.#\{ type \}
    # @param metadata [Hash]
    # @return [String, nil] HTML
    def hint_of(metadata)
      type = metadata[:type]
      hint = metadata[:hint]
      # @see http://guides.rubyonrails.org/i18n.html#using-safe-html-translations
      hint ||= type && wt("hints.#{type}_html", default: [:"hints.#{type}", ''])
      return if hint.blank?

      content_tag :p, hint, class: 'help-block'
    end
  end
end
