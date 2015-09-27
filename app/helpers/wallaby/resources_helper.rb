module Wallaby
  module ResourcesHelper
    def type_partial_render options = {}, locals = {}, &block
      if lookup_context.exists?(options, lookup_context.prefixes, true)
        render options, locals, &block
      else
        locals[:value]
      end
    end

    def form_type_partial_render options = {}, locals = {}, &block
      if lookup_context.exists?(options, lookup_context.prefixes, true)
        render options, locals, &block
      else
        case options.to_s
        when 'text'
          locals[:form].text_area locals[:field_name], class: 'form-control'
        else
          locals[:form].text_field locals[:field_name], class: 'form-control'
        end
      end
    end

    def null
      unless Wallaby.configuration.display_null == false
        content_tag :i, '<null>', "class" => 'text-muted'
      end
    end

    def i_tooltip title, icon = "info-sign"
      content_tag :i, nil, "class" => "glyphicon glyphicon-#{ icon }", "data-toggle" => "tooltip", "data-placement" => "top", "title" => title
    end

    def breadcrumb_components
      request.env['PATH_INFO'].split('/').reject{ |v| v.blank? }
    end

    def breadcrumb_item_for component, last_component = breadcrumb_components.last
      if component != last_component
        if component == resources_name
          link_to ct("breadcrumb.#{ component }"), wallaby_engine.resources_path
        elsif component == id
          link_to ct('breadcrumb.show'), wallaby_engine.resource_path
        end
      else
        ct "breadcrumb.#{ component == id ? 'show' : component }"
      end
    end

    def index_link options = {}, title = nil, resources = nil
      resources ||= resources_name
      title     ||= ct(resources)
      link_to title, wallaby_engine.resources_path, options
    end

    def new_link options = {}, title = nil, resources = nil
      resources ||= resources_name
      title     ||= ct('link.new')
      link_to title, wallaby_engine.new_resource_path, options
    end

    def show_link resource, options = {}, title = nil, resources = nil
      resources ||= resources_name
      title     ||= ct('link.show')
      is_button = options.delete(:button)
      options[:title] = title and title = '' if is_button
      link_to title, wallaby_engine.resource_path(resources, resource), options
    end

    def edit_link resource, options = {}, title = nil, resources = nil
      resources ||= resources_name
      title     ||= ct('link.edit')
      is_button = options.delete(:button)
      options[:title] = title and title = '' if is_button
      link_to title, wallaby_engine.edit_resource_path(resources, resource), options
    end

    def delete_link resource, options = {}, title = nil, confirm = nil, resources = nil
      resources ||= resources_name
      title     ||= ct('link.delete')
      confirm   ||= ct('link.confirm.delete')
      is_button = options.delete(:button)
      options[:title] = title and title = '' if is_button
      link_to title, wallaby_engine.resource_path(resources, resource), options.merge(method: :delete, confirm: confirm)
    end

    def cancel_link title = nil, options = {}
      title ||= ct('cancel')
      is_button = options.delete(:button)
      options[:title] = title and title = '' if is_button
      link_to title, :back, class: 'button small'
    end
  end
end