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

    # Render partial for index/show
    def type_partial_render(options = {}, locals = {}, &block)
      Utils.deprecate 'deprecation.type_partial_render', caller: caller
      type_render options, locals, &block
    end

    # Render type cell/partial
    def type_render(options = {}, locals = {}, &block)
      TypeRenderer.render self, options, locals, &block
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
