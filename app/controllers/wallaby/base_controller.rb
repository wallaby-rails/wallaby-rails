module Wallaby
  # Base controller to provide basic helper methods for sub classes
  class BaseController < ::Wallaby::SecureController
    helper BaseHelper

    before_action :authenticate_user!, except: [:status]

    def healthy
      render plain: 'healthy'
    end

    protected

    # helper methods
    begin
      helper_method \
        :current_resources_name,
        :current_model_class

      def current_resources_name
        @current_resources_name ||= params[:resources]
      end

      def current_model_class
        @current_model_class ||=
          self.class.respond_to?(:model_class) && self.class.model_class \
          || Map.model_class_map(current_resources_name)
      end
    end
  end
end
