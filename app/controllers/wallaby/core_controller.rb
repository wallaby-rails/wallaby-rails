module Wallaby
  class CoreController < SecureController
    def status
      render text: 'ok'
    end

    begin # global helpers
      def model_classes
        @model_classes ||= begin
          classes = Wallaby.configuration.model_finder.new.available_model_classes
          classes.map do |klass|
            Wallaby.configuration.model_decorator.new klass
          end
        end
      end

      helper_method :model_classes
    end
  end
end