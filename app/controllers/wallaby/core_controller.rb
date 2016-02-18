module Wallaby
  class CoreController < SecureController
    before_action :authenticate_user!, except: [ :status ]

    def status
      render text: 'healthy'
    end

    protected
    begin # helper methods
      helper_method \
        :current_resources_name,
        :current_model_class

      def current_resources_name
        @current_resources_name ||= if self.class.respond_to? :resources_name
          self.class.resources_name
        end || params[:resources]
      end

      def current_model_class
        @current_model_class ||= if self.class.respond_to? :model_class
          self.class.model_class
        end || Wallaby::Utils.to_model_class(current_resources_name)
      end
    end
  end
end
