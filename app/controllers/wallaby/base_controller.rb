module Wallaby
  # Base controller to provide basic helper methods.
  class BaseController < ::Wallaby::SecureController
    helper BaseHelper
    helper_method :current_resources_name, :current_model_class

    # @return [String] resources name
    def current_resources_name
      @current_resources_name ||= params[:resources] || Utils.try_to(self.class, :resources_name)
    end

    # Get the model class from the following two sources:
    #
    # - class attribute method `model_class``
    # - model class converted from {current_resources_name}
    # @return [Class] model class
    def current_model_class
      @current_model_class ||= Utils.try_to(self.class, :model_class) do
        Map.model_class_map(current_resources_name)
      end
    end
  end
end
