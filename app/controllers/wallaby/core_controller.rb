module Wallaby
  class CoreController < SecureController
    include CoreMethods

    before_action :build_up_view_paths

    def status
      render text: 'ok'
    end

    begin # global helpers
      def model_classes
        @model_classes ||= Wallaby.adaptor.model_finder.new.available_model_classes
      end

      helper_method :model_classes
    end
  end
end