module Wallaby
  # Helper methods to build custom elements
  module StylingHelper
    # Shortcut to build up the HTML options as keyword arguments
    # @param string_or_array [String, Array<String>]
    # @param options [Hash]
    # @return [Hash]
    def html_classes(string_or_array, options = {})
      { html_options: options.merge(class: string_or_array) }
    end

    # @deprecated Use {#glyph_icon} instead. It will be removed from 5.3.*
    def fa_icon(*args, &block)
      Utils.deprecate 'deprecation.fa_icon', caller: caller
      html_options = args.extract_options!
      html_options[:class] = Array html_options[:class]
      html_options[:class] << 'fa'
      args.each { |suffix| html_options[:class] << "fa-#{suffix}" }

      content_tag :i, nil, html_options, &block
    end

    # Shortcut to generate Glyph icon using tag <i>.
    # @overload glyph_icon(*names, html_options)
    #   @param names [Array<String>] names of the icon
    #   @param html_options [Hash] HTML options for tag <i>
    # @return [String] HTML I element
    def glyph_icon(*args, &block)
      html_options = args.extract_options!
      html_options[:class] = Array html_options[:class]
      html_options[:class] << 'glyphicon'
      args.each { |suffix| html_options[:class] << "glyphicon-#{suffix}" }

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

      glyph_icon icon_suffix, html_options
    end

    # Build up modal
    # @param title [String]
    # @param body [String]
    # @param html_options [Hash]
    # @return [String] modal HTML
    def imodal(title, body, html_options = {})
      label ||= html_options.delete(:label) \
                  || html_options.delete(:icon) || glyph_icon('clone')
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
