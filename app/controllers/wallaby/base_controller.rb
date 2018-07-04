module Wallaby
  # Base controller to provide basic helper methods.
  class BaseController < ::Wallaby::SecureController
    helper BaseHelper
    helper_method :current_resources_name, :current_model_class

    # @return [String] resources name
    def current_resources_name
      @current_resources_name ||= params[:resources] || from_class_method(:resources_name)
    end

    # Get the model class from the following two sources:
    #
    # - class attribute method `model_class``
    # - model class converted from {current_resources_name}
    # @return [Class] model class
    def current_model_class
      @current_model_class ||= from_class_method :model_class do
        Map.model_class_map(current_resources_name)
      end
    end

    protected

    def from_class_method(method_name, &block)
      block ||= -> { }
      self.class.respond_to?(method_name) && self.class.public_send(method_name) || block.call
    end
  end
end
