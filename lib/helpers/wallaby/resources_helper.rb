module Wallaby
  # Resources helper
  module ResourcesHelper
    include FormHelper
    include SortingHelper
    include PaginatableHelper
    include IndexHelper

    def model_decorator(model_class)
      Map.model_decorator_map model_class
    end

    def model_servicer(model_class, authorizer = current_ability)
      Map.servicer_map(model_class).new(model_class, authorizer)
    end

    def decorate(resource, _metadata = {})
      return resource if resource.blank?

      if resource.respond_to? :map # collection
        all = resource.to_a
        return all if all.first.is_a? ResourceDecorator
        all.map { |item| decorate item }
      else
        decorator = Map.resource_decorator_map resource.class
        decorator.decorate resource
      end
    end

    def extract(resource)
      if resource.is_a? ResourceDecorator
        resource.resource
      else
        resource
      end
    end

    def index_type_partial_render(options = {}, locals = {}, &block)
      type_partial_render options, locals, :index_metadata_of, &block
    end

    def show_title(decorated)
      raise ::ArgumentError unless decorated.is_a? ResourceDecorator
      [
        to_model_label(decorated.model_class), decorated.to_label
      ].compact.join ': '
    end

    def default_metadata
      Wallaby.configuration.metadata
    end

    def type_partial_render(options = {},
                            locals = {},
                            metadata_method = :show_metadata_of, &block)
      decorated   = locals[:object]
      field_name  = locals[:field_name].to_s

      unless field_name.present? && decorated.is_a?(ResourceDecorator)
        raise ::ArgumentError
      end

      locals[:metadata] = decorated.send metadata_method, field_name
      locals[:value]    = decorated.public_send field_name

      # NOTE: what happen here is that
      # if desired partial is not found, it won't throw an exception
      # instead, it will render the string partial instead
      render(options, locals, &block) || render('string', locals, &block)
    end
  end
end
