module Wallaby
  # Easter egg: simple responder for JSON API
  class JsonApiResponder < ActionController::Responder
    include ResourcesHelper

    delegate :params, :headers, to: :request

    # @see #to_json
    def to_html
      to_json
    end

    # @return [String] JSON
    def to_json
      with_options content_type: 'application/vnd.api+json' do |opts|
        if !get? && has_errors?
          opts.render json: resource_errors, status: :unprocessable_entity
        elsif exception?
          opts.render json: exception_details, status: options[:status]
        elsif index?
          opts.render json: collection_data
        else
          opts.render json: resource_data
        end
      end
    end

    protected

    def single(resource)
      {
        id: resource.id,
        type: ModelUtils.to_resources_name(resource.class),
        attributes: attributes_of(resource)
      }
    end

    def collection_data
      {
        data: resource.map(&method(:single))
      }
    end

    def resource_data
      {
        data: single(resource)
      }
    end

    def resource_errors
      decorated = decorate resource
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
      decorated = decorate resource
      field_names = index? ? decorated.index_field_names : decorated.show_field_names
      field_names.each_with_object({}) do |name, attributes|
        attributes[name] = decorated.public_send name
      end
    end

    def exception_details
      { errors: [{status: options[:status],detail: resource.try(:message)}]}
    end

    def index?
      params[:action] == 'index'
    end

    def exception?
      (resource.nil? || resource.is_a?(Exception)) && options[:template] == ERROR_PATH
    end
  end
end
