module Wallaby
  # Resources helper
  module ResourcesHelper
    include BaseHelper
    include FormHelper
    include IndexHelper

    include Authorizable
    include Decoratable
    include Paginatable
    include Resourcable
    include Themeable

    # Wrap resource into a decorator
    # @param resource [Object, Enumerable]
    # @return [Wallaby::ResourceDecorator, Enumerable<Wallaby::ResourceDecorator>]
    def decorate(resource)
      return resource if resource.is_a? ResourceDecorator
      return resource.map { |item| decorate item } if resource.respond_to? :map
      decorator = Map.resource_decorator_map resource.class
      decorator ? decorator.new(resource) : resource
    end

    # Get the origin resource object
    # @param resource [Object, Wallaby::ResourceDecorator]
    # @return [Object]
    def extract(resource)
      return resource.resource if resource.is_a? ResourceDecorator
      resource
    end

    # @deprecated Use {#type_render} instead. It will be removed from 5.3.*
    def type_partial_render(options = {}, locals = {}, &block)
      Utils.deprecate 'deprecation.type_partial_render', caller: caller
      type_render options, locals, &block
    end

    # Render type cell/partial
    # @param partial_name [String]
    # @param locals [Hash]
    def type_render(partial_name = '', locals = {}, &block)
      TypeRenderer.render self, partial_name, locals, &block
    end

    # Title for show page of given resource
    # @param decorated [Wallaby::ResourceDecorator]
    # @return [String]
    def show_title(decorated)
      raise ::ArgumentError unless decorated.is_a? ResourceDecorator
      [
        to_model_label(decorated.model_class), decorated.to_label
      ].compact.join ': '
    end
  end
end
