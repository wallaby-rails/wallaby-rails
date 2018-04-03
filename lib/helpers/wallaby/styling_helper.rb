module Wallaby
  # Styling helper
  module StylingHelper
    # Shortcut to build up the html options as keyword arguments
    # @param string_or_array [String, Array<String>]
    # @return [Hash]
    def html_classes(string_or_array)
      { html_options: { class: string_or_array } }
    end

    # Shortcut for fontawesome icons
    # @param icon_suffix [String]
    # @param html_options [Hash]
    # @return [String] HTML I element
    def fa_icon(icon_suffix, html_options = {}, &block)
      html_options[:class] = Array html_options[:class]
      html_options[:class] << "fa fa-#{icon_suffix}"

      content_tag :i, nil, html_options, &block
    end

    # Build up tooltip
    # @param title [String]
    # @param icon_suffix [String]
    # @param html_options [Hash]
    # @return [String] tooltip HTML
    def itooltip(title, icon_suffix = 'info-circle', html_options = {})
      html_options[:title] = title
      (html_options[:data] ||= {}).merge! toggle: 'tooltip', placement: 'top'

      fa_icon icon_suffix, html_options
    end

    # Build up modal
    # @param title [String]
    # @param body [String]
    # @param html_options [Hash]
    # @return [String] modal HTML
    def imodal(title, body, html_options = {})
      label ||= html_options.delete(:label) \
                  || html_options.delete(:icon) || fa_icon('clone')
      content_tag :span, class: 'modaler' do
        concat link_to(label, '#', data: { target: '#imodal', toggle: 'modal' })
        concat content_tag(:span, title, class: 'modaler__title')
        concat content_tag(:span, body, class: 'modaler__body')
      end
    end

    # @return [String] grey null
    def null
      muted t 'labels.empty'
    end

    # @return [String] grey N/A
    def na
      muted t 'labels.na'
    end

    # Grey text
    # @param text_content [String]
    # @return [String] HTML I element
    def muted(text_content)
      content_tag :i, "<#{text_content}>", class: 'text-muted'
    end
  end
end
