require 'securerandom'

module Wallaby::ResourcesHelper
  def type_partial_render(options = {}, locals = {}, &block)
    fail ArgumentError unless %i( object field_name ).all?{ |key| locals.has_key? key } && locals[:object].is_a?(Wallaby::ResourceDecorator)
    locals[:metadata] = locals[:object].metadata_of locals[:field_name]
    locals[:value] = locals[:object].send(locals[:field_name]).tap do |value|
      value = decorate value if locals[:metadata][:is_association]
    end
    render options, locals, &block or locals[:value]
  end

  def form_type_partial_render(options = {}, locals = {}, &block)
    fail ArgumentError unless %i( form field_name ).all?{ |key| locals.has_key? key }
    options = "form/#{ options }" if options.is_a? String
    locals[:object] = locals[:form].object
    locals[:value] = locals[:object].send locals[:field_name]
    locals[:metadata] = locals[:object].metadata_of locals[:field_name]
    render options, locals, &block or
      default_rendered = \
        case options.to_s
        when 'text'
          locals[:form].text_area locals[:field_name], class: 'form-control'
        else
          locals[:form].text_field locals[:field_name], class: 'form-control'
        end
  end

  def null
    content_tag :i, '<null>', class: 'text-muted'
  end

  def i_tooltip(title, icon = "info-sign")
    content_tag :i, nil, title: title, class: "glyphicon glyphicon-#{ icon }",
      data: { toggle: "tooltip", placement: "top" }
  end

  def open_model(title, body, label = nil)
    uuid = random_uuid
    label ||= content_tag :i, nil, class: 'glyphicon glyphicon-circle-arrow-up'
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

  def index_link(options = {}, title = nil, resources = nil)
    resources ||= resources_name
    title     ||= ct(resources)
    link_to title, wallaby_engine.resources_path, options
  end

  def new_link(options = {}, title = nil, resources = nil)
    resources ||= resources_name
    title     ||= ct('link.new')
    link_to title, wallaby_engine.new_resource_path, options
  end

  def show_link(resource, options = {}, title = nil, resources = nil)
    resources ||= resources_name
    title     ||= ct('link.show')
    is_button = options.delete(:button)
    options[:title] = title and title = '' if is_button
    link_to title, wallaby_engine.resource_path(resources, resource), options
  end

  def edit_link(resource, options = {}, title = nil, resources = nil)
    resources ||= resources_name
    title     ||= ct('link.edit')
    is_button = options.delete(:button)
    options[:title] = title and title = '' if is_button
    link_to title, wallaby_engine.edit_resource_path(resources, resource), options
  end

  def delete_link(resource, html_options = {}, title = nil, confirm = nil, resources = nil)
    resources ||= resources_name
    title     ||= ct('link.delete')
    confirm   ||= ct('link.confirm.delete')
    is_button = html_options.delete(:button)
    html_options[:title] = title and title = '' if is_button
    options = {
      url: wallaby_engine.resource_path(resources, resource),
      method: :delete,
      confirm: confirm
    }
    link_to title, wallaby_engine.resource_path(resources, resource), html_options.merge(options)
  end

  def cancel_link(title = nil, options = {})
    title ||= ct('cancel')
    is_button = options.delete(:button)
    options[:title] = title and title = '' if is_button
    link_to title, :back, options
  end

  def show_title decorator
    [ decorator.model_label, decorator.to_label ].compact.join ': '
  end

  def link_to_resource(resource = nil, klass = nil)
    if resource
      decorated = resource.decorate
      link_to decorated.to_label, wallaby_engine.resource_path(decorated.resources_name, decorated)
    else
      this_model_decorator = model_decorator(klass)
      link_to wallaby_engine.new_resource_path(this_model_decorator.resources_name) do
        'Create one'
      end
    end
  end

  def random_uuid
    SecureRandom.uuid
  end

  def resource_links
    decorated = decorate resource
    links = [ index_link({}, 'List') ]
    if decorated.send decorated.primary_key
      links << show_link(decorated) if params[:action] == 'edit'
      links << edit_link(decorated) if params[:action] == 'show'
      links << delete_link(decorated, class: 'text-danger')
    end
    links
  end

  def model_choices(this_model_decorator)
    choices = this_model_decorator.search.map do |item|
      decorated = item.decorate
      [ decorated.to_label, decorated.send(decorated.primary_key) ]
    end
  end
end
