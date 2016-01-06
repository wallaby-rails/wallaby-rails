module Wallaby
  class CoreController < SecureController
    include CoreMethods
    before_action :authenticate_user!, except: [ :status ]
    helper_method :model_classes

    def status
      render text: 'healthy'
    end

    protected
    def model_classes
      @model_classes ||= Wallaby.configuration.adaptor.model_finder.new.available
    end
  end
end
