module Wallaby
  module ResourcesHelper
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
      link_to title, wallaby_engine.resource_path(resources), options
    end

    def new_link options = {}, title = nil, resources = nil
      resources ||= resources_name
      title     ||= ct('new')
      link_to title, wallaby_engine.resource_path(resources), options
    end

    def show_link id, options = {}, title = nil, resources = nil
      resources ||= resources_name
      title     ||= ct('show')
      link_to title, wallaby_engine.resource_path(resources, id), options
    end

    def edit_link id, options = {}, title = nil, resources = nil
      resources ||= resources_name
      title     ||= ct('edit')
      link_to title, wallaby_engine.edit_resource_path(resources, id), options
    end

    def delete_link id, options = {}, title = nil, confirm = nil, resources = nil
      resources ||= resources_name
      title     ||= ct('delete')
      confirm   ||= ct('confirm.delete')
      link_to title, wallaby_engine.resource_path(resources, id), options.merge(method: :delete, confirm: confirm)
    end

    def cancel_link title = nil
      title ||= ct('cancel')
      link_to title, :back
    end
  end
end