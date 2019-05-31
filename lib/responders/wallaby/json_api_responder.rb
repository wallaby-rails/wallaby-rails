module Wallaby
  # Easter egg: simple responder for JSON API
  class JsonApiResponder < ResourcesResponder
    delegate :params, :headers, to: :request

    # @see #to_json
    def to_html
      to_json
    end

    # @return [String] JSON
    def to_json(*)
      json_options = { content_type: 'application/vnd.api+json', status: options[:status] }
      if exception?
        render json_options.merge(json: exception_details)
      else
        render json_options.merge(action_options)
      end
    end

    protected

    def action_options
      if !get? && has_errors?
        { json: resource_errors, status: :unprocessable_entity }
      elsif index?
        { json: collection_data }
      else
        { json: resource_data }
      end
    end

    def single(resource)
      {
        id: resource.id,
        type: params[:resources],
        attributes: attributes_of(resource)
      }
    end

    def collection_data
      {
        data: resource.map(&method(:single)),
        links: {
          self: controller.url_for(resources: params[:resources], action: 'index')
        }
      }
    end

    def resource_data
      {
        data: single(resource),
        links: {
          self: controller.url_for(resources: params[:resources], action: 'show', id: resource.id)
        }
      }
    end

    def resource_errors
      decorated = controller.decorate resource
      {
        errors: decorated.errors.each_with_object([]) do |(field, message), json|
          json.push(
            status: 422,
            source: { pointer: "/data/attributes/#{field}" },
            detail: message
          )
        end
      }
    end

    def attributes_of(resource)
      decorated = controller.decorate resource
      field_names = index? ? decorated.index_field_names : decorated.show_field_names
      field_names.each_with_object({}) do |name, attributes|
        attributes[name] = decorated.public_send name
      end
    end

    def exception_details
      {
        errors: [
          {
            status: options[:status],
            detail: resource.try(:message)
          }
        ]
      }
    end

    def index?
      params[:action] == 'index'
    end

    def exception?
      (resource.nil? || resource.is_a?(Exception)) && options[:template] == ERROR_PATH
    end
  end
end
