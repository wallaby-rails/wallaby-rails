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
      uuid = random_uuid
      label ||= imodal_label(html_options)
      link = link_to \
        label, 'javascript:;', data: { toggle: 'modal', target: "##{uuid}" }
      link + imodal_html(uuid, title, body)
    end

    def null
      muted 'null'
    end

    def na
      muted 'n/a'
    end

    def muted(content)
      content_tag :i, "<#{content}>", class: 'text-muted'
    end

    def imodal_label(html_options)
      html_options.delete(:label) ||
        html_options.delete(:icon) ||
        fa_icon('clone')
    end

    def imodal_html(uuid, title, body)
      container_options = {
        id: uuid, class: 'modal fade', tabindex: -1, role: 'dialog'
      }
      content_tag(:div, container_options) do
        content_tag :div, class: 'modal-dialog modal-lg' do
          content_tag :div, class: 'modal-content' do
            imodal_header(title) + imodal_body(body)
          end
        end
      end
    end

    def imodal_header(title)
      content_tag(:div, class: 'modal-header') do
        button_options = {
          type: 'button', class: 'close',
          data: { dismiss: 'modal' }, aria: { label: 'Close' }
        }
        button_tag(button_options) do
          content_tag :span, raw('&times;'), aria: { hidden: true }
        end +
          content_tag(:h4, title, class: 'modal-title')
      end
    end

    def imodal_body(body)
      content_tag(:div, class: 'modal-body') { body }
    end
  end
end
