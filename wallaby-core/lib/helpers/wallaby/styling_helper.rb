# frozen_string_literal: true

module Wallaby
  # Helper methods to build custom elements
  module StylingHelper
    # backforward compatible with FontAwesome 4
    # @see this fa migration document https://fontawesome.com/how-to-use/on-the-web/setup/upgrading-from-version-4
    FONT_AWESOME_MAPPING = {
      4 => {
        clock: 'clock-o',
        bars: 'navicon',
        calendar: 'calendar-o',
        'check-square': 'check-square-o',
        square: 'square-o',
        link: 'chain',
        user: 'user-o'
      }
    }.with_indifferent_access.freeze

    # Shortcut to build up the HTML options as keyword arguments
    # @param string_or_array [String, Array<String>]
    # @param options [Hash]
    # @return [Hash]
    def html_classes(string_or_array, options = {})
      { html_options: options.merge(class: string_or_array) }
    end

    # Shortcut to generate FontAwesome icon using tag <i>.
    # @overload fa_icon(*names, html_options)
    #   @param names [Array<String>] names of the icon
    #   @param html_options [Hash] HTML options for tag <i>
    # @return [String] HTML I element
    def fa_icon(*args, &block)
      html_options = args.extract_options!
      html_options[:class] = Array html_options[:class]
      html_options[:class] << 'fa'
      args.each { |suffix| html_options[:class] << "fa-#{fa_map suffix}" }

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
      muted wt 'labels.empty'
    end

    # @return [String] grey N/A
    def na
      muted wt 'labels.na'
    end

    # Grey text
    # @param text_content [String]
    # @return [String] HTML I element
    def muted(text_content)
      content_tag :i, "<#{text_content}>", class: 'text-muted'
    end

    # @param name [String]
    # @return [String] FontAwesome icon name
    def fa_map(name, major = nil)
      @map ||= begin
        major ||= Gem.loaded_specs['font-awesome-sass'].try(:version).try(:segments).try(:first)
        FONT_AWESOME_MAPPING[major] || {}
      end
      @map[name] || name
    end
  end
end
