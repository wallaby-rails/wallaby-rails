module Wallaby
  # Abstract model authorizer to provide authorization functions
  class AbstractModelAuthorizer
    extend Abstractable::ClassMethods
    class << self
      # @!attribute [w] model_class
      attr_writer :model_class

      # @!attribute [r] model_class
      # This method is used to index the authorizer.
      # @return [Class] model class
      # @return [nil] if abstract or not found
      def model_class
        return unless self < ModelAuthorizer
        return if abstract || self == Wallaby.configuration.mapping.model_authorizer
        @model_class ||= Map.model_class_map(name.gsub('Authorizer', EMPTY_STRING))
      end

      # @!attribute [w] provider_name
      attr_writer :provider_name

      # @!attribute [r] provider_name
      # This method is used to index the provider.
      # If it's not set, it will inherit from super class.
      # @return [String, Symbol] provider name
      def provider_name
        @provider_name ||= Utils.try_to superclass, :provider_name
      end
    end

    delegate(*(ModelAuthorizationProvider.instance_methods - ::Object.instance_methods), to: :@provider)

    # @param context [ActionController::Base]
    # @param model_class [Class]
    def initialize(context, model_class)
      @model_class = self.class.model_class || model_class
      @provider = init_provider context
    end

    protected

    # Go through provider list and detect which provider to be used.
    # @param context [ActionController::Base]
    # @return [Wallaby::Authorizer]
    def init_provider(context)
      providers = Map.authorizer_provider_map @model_class
      provider_class = providers[self.class.provider_name]
      provider_class ||= providers.values.find { |klass| klass.available? context }
      provider_class.new context
    end
  end
end
