module Wallaby
  # Resources helper
  module ResourcesHelper
    include Themeable
    include FormHelper
    include IndexHelper

    # @see Map.model_decorator_map
    # @return [Wallaby::ModelDecorator]
    def model_decorator(model_class)
      Map.model_decorator_map model_class
    end

    # @see Map.authorizer_map
    # @return [Wallaby::ModelAuthorizer]
    def model_authorizer(model_class)
      Map.authorizer_map model_class
    end

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
      PartialRenderer.render self, options, locals, params[:action], &block
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
