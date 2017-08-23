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

    def imodal_label(html_options)
      warn '[DEPRECATION] `imodal_label` will be removed in version 5.2.0.'
      html_options.delete(:label) ||
        html_options.delete(:icon) ||
        fa_icon('clone')
    end

    def imodal_html(uuid, title, body)
      warn '[DEPRECATION] `imodal_html` will be removed in version 5.2.0.'
      container_options =
        { id: uuid, class: 'modal fade', tabindex: -1, role: 'dialog' }
      content_tag(:div, container_options) do
        content_tag :div, class: 'modal-dialog modal-lg' do
          content_tag :div, class: 'modal-content' do
            imodal_header(title) + imodal_body(body)
          end
        end
      end
    end

    def imodal_header(title)
      warn '[DEPRECATION] `imodal_header` will be removed in version 5.2.0.'
      content_tag(:div, class: 'modal-header') do
        concat imodal_button
        concat content_tag(:h4, title, class: 'modal-title')
      end
    end

    def imodal_body(body)
      warn '[DEPRECATION] `imodal_body` will be removed in version 5.2.0.'
      content_tag(:div, class: 'modal-body') { body }
    end

    def imodal_button
      warn '[DEPRECATION] `imodal_button` will be removed in version 5.2.0.'
      button_options = {
        type: 'button', class: 'close',
        data: { dismiss: 'modal' }, aria: { label: 'Close' }
      }
      button_tag(button_options) do
        content_tag :span, raw('&times;'), aria: { hidden: true }
      end
    end
  end
end
