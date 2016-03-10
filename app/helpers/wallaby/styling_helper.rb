module Wallaby::StylingHelper
  def icon(icon_suffix, html_options = {}, &block)
    html_options[:class] = Array html_options[:class]
    html_options[:class] << "glyphicon glyphicon-#{ icon_suffix }"

    content_tag :i, nil, html_options, &block
  end

  def itooltip(title, icon_suffix = 'info-sign', html_options = {})
    html_options[:title] = title
    (html_options[:data] ||= {}).merge! toggle: "tooltip", placement: "top"

    icon icon_suffix, html_options
  end

  def ilink_to(options = nil, html_options = {})
    icon_suffix = html_options.delete(:icon) || 'info-sign'
    link_to options, html_options do
      icon icon_suffix
    end
  end

  def imodal(title, body, label = nil)
    uuid = random_uuid
    label ||= icon 'circle-arrow-up'
    link_to(label, 'javascript:;', data: { toggle: 'modal', target: "##{ uuid }" }) +
    content_tag(:div, id: uuid, class: 'modal fade', tabindex: -1, role: 'dialog') do
      content_tag :div, class: 'modal-dialog modal-lg' do
        content_tag :div, class: 'modal-content' do
          content_tag(:div, class: 'modal-header') do
            button_tag(type: 'button', class: 'close', data: { dismiss: 'modal' }, aria: { label: 'Close' }) do
              content_tag :span, raw('&times;'), aria: { hidden: true }
            end +
            content_tag(:h4, title, class: 'modal-title')
          end +
          content_tag(:div, class: 'modal-body') do
            body
          end
        end
      end
    end
  end

  def null
    content_tag :i, '<null>', class: 'text-muted'
  end

  def na
    content_tag :i, '<n/a>', class: 'text-muted'
  end
end
