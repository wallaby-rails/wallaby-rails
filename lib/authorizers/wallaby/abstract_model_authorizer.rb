module Wallaby
  # Model Authorizer to provide authroization functions
  class AbstractModelAuthorizer
    class << self
      attr_writer :model_class
      attr_writer :provider

      def model_class
        return unless self < ModelAuthorizer
        @model_class || Map.model_class_map(name.gsub('Authorizer', EMPTY_STRING))
      end

      def provider
        @provider ||= superclass.respond_to?(:provider) ? superclass.provider : nil
      end
    end

    # Delegate methods to pagination provider
    delegate(*(ModelAuthorizationProvider.instance_methods - ::Object.instance_methods), to: :@provider)

    # @param context [ActionController::Base]
    def initialize(context, model_class)
      @model_class = self.class.model_class || model_class
      @provider = init_provider(self.class.provider, context)
    end

    protected

    def init_provider(_provider, context)
      Wallaby::ActiveRecord::CancancanProvider.new context
    end
  end
end
