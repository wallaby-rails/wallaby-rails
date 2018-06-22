module Wallaby
  # Model Authorizer to provide authorization functions
  class AbstractModelAuthorizer
    include Abstractable
    class << self
      attr_writer :model_class
      attr_writer :provider_name

      # This method is used to index the authorizer.
      # @return [Class, nil] model class
      def model_class
        return unless self < ModelAuthorizer
        return if abstract || self == Wallaby.configuration.mapping.model_authorizer
        @model_class || Map.model_class_map(name.gsub('Authorizer', EMPTY_STRING))
      end

      # This method is used to index the provider.
      # If it's not set, it will inherit from super class.
      # @return [String, Symbol] provider name
      def provider_name
        @provider_name ||= superclass.respond_to?(:provider_name) ? superclass.provider_name : nil
      end
    end

    delegate(*(ModelAuthorizationProvider.instance_methods - ::Object.instance_methods), to: :@provider)

    # @param model_class [Class]
    # @param context [ActionController::Base]
    def initialize(context, model_class)
      @model_class = self.class.model_class || model_class
      @provider = init_provider context
    end

    protected

    def init_provider(context)
      providers = Map.authorizer_provider_map @model_class
      provider_class = providers[self.class.provider_name]
      provider_class ||= providers.values.find { |klass| klass.available? context }
      raise InvalidError unless provider_class
      provider_class.new context
    end
  end
end
