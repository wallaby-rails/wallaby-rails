module Wallaby
  # Styling helper
  module StylingHelper
    def fa_icon(icon_suffix, html_options = {}, &block)
      html_options[:class] = Array html_options[:class]
      html_options[:class] << "fa fa-#{icon_suffix}"

      content_tag :i, nil, html_options, &block
    end

    def itooltip(title, icon_suffix = 'info-circle', html_options = {})
      html_options[:title] = title
      (html_options[:data] ||= {}).merge! toggle: 'tooltip', placement: 'top'

      fa_icon icon_suffix, html_options
    end

    def imodal(title, body, html_options = {})
      label ||= html_options.delete(:label) \
                  || html_options.delete(:icon) || fa_icon('clone')
      content_tag :span, class: 'modaler' do
        concat link_to(label, '#', data: { target: '#imodal', toggle: 'modal' })
        concat content_tag(:span, title, class: 'modaler__title')
        concat content_tag(:span, body, class: 'modaler__body')
      end
    end

    def null
      muted 'null'
    end

    def na
      muted 'n/a'
    end

    def muted(text_content)
      content_tag :i, "<#{text_content}>", class: 'text-muted'
    end
  end
end
