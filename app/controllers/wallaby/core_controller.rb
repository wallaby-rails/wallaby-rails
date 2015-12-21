module Wallaby
  class CoreController < SecureController

    helper_method :model_classes

    include CoreMethods

    def status
      render text: 'healthy'
    end

    protected
    def model_classes
      @model_classes ||= Wallaby.configuration.adaptor.model_finder.new.available
    end
  end
end