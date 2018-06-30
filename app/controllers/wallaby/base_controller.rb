module Wallaby
  # Base controller to provide basic helper methods.
  class BaseController < ::Wallaby::SecureController
    helper BaseHelper
    helper_method \
      :current_resources_name,
      :current_model_class

    # @return [String] the resources name coming from params
    def current_resources_name
      @current_resources_name ||= params[:resources]
    end

    # Get the model class from the following two sources:
    #
    # - class attribute method `model_class``
    # - model class converted from {current_resources_name}
    # @return [Class] the model class that links to the resources name
    def current_model_class
      @current_model_class ||=
        self.class.respond_to?(:model_class) && self.class.model_class \
        || Map.model_class_map(current_resources_name)
    end
  end
end
