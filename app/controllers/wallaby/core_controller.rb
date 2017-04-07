module Wallaby
  # Core controller to provide basic helper methods for sub classes
  class CoreController < SecureController
    helper Wallaby::CoreHelper

    before_action :authenticate_user!, except: [:status]

    def status
      render plain: 'healthy'
    end

    protected

    begin # helper methods
      helper_method \
        :current_resources_name,
        :current_model_class

      def current_resources_name
        @current_resources_name ||= params[:resources]
      end

      def current_model_class
        @current_model_class ||=
          self.class.respond_to?(:model_class) && self.class.model_class \
          || Wallaby::Utils.to_model_class(current_resources_name)
      end
    end
  end
end
