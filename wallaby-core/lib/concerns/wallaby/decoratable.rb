# frozen_string_literal: true

module Wallaby
  # Decorator related
  module Decoratable
    # Get current model decorator. It comes from
    #
    # - model decorator for {Configurable::ClassMethods#resource_decorator resource_decorator}
    # - otherwise, model decorator for {Configurable::ClassMethods#application_decorator application_decorator}
    #
    # Model decorator stores the information of **metadata** and **field_names** for **index**/**show**/**form** action.
    # @return [ModelDecorator] current model decorator for this request
    def current_model_decorator
      @current_model_decorator ||=
        current_decorator.try(:model_decorator) || \
        Map.model_decorator_map(current_model_class, wallaby_controller.application_decorator)
    end

    # Get current resource decorator. It comes from
    #
    # - {Configurable::ClassMethods#resource_decorator resource_decorator}
    # - otherwise, {Configurable::ClassMethods#application_decorator application_decorator}
    # @return [ResourceDecorator] current resource decorator for this request
    def current_decorator
      @current_decorator ||=
        decorator_of(current_model_class).tap do |decorator|
          Logger.debug %(Current decorator: #{decorator}), sourcing: false
        end
    end

    # Get current fields metadata for current action name.
    # @return [Hash] current fields metadata
    def current_fields
      @current_fields ||=
        current_model_decorator.try(:"#{action_name}_fields")
    end

    # Get the decorator of a klass
    def decorator_of(klass)
      DecoratorFinder.new(
        script_name: script_name,
        model_class: klass,
        current_controller_class: wallaby_controller
      ).execute
    end

    # Wrap resource(s) with decorator(s).
    # @param resource [Object, Enumerable]
    # @return [ResourceDecorator, Enumerable<Wallaby::ResourceDecorator>] decorator(s)
    def decorate(resource)
      return resource if resource.is_a?(ResourceDecorator)
      return resource.map { |item| decorate(item) } if resource.respond_to?(:map)
      return resource unless Map.mode_map[resource.class]

      DecoratorFinder.new(
        script_name: script_name,
        model_class: resource.class,
        current_controller_class: wallaby_controller
      ).execute.new(resource)
    end

    # @param resource [Object, Wallaby::ResourceDecorator]
    # @return [Object] the unwrapped resource object
    def extract(resource)
      return resource.resource if resource.is_a?(ResourceDecorator)

      resource
    end
  end
end
