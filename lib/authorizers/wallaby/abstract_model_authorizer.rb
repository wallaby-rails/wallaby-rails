module Wallaby
  # Abstract model authorizer to provide authorization functions
  # @since 5.2.0
  class AbstractModelAuthorizer
    extend Baseable::ClassMethods

    class << self
      # @!attribute [w] model_class
      attr_writer :model_class

      # @!attribute [r] model_class
      # Associated model class.
      # @return [Class] assoicated model class
      # @return [nil] if current class is marked as base class
      # @return [nil] if current class is the same as the value of {Wallaby::Configuration::Mapping#model_authorizer}
      # @return [nil] if current class is {Wallaby::ModelAuthorizer}
      # @return [nil] if assoicated model class is not found
      def model_class
        return unless self < ModelAuthorizer
        return if base_class? || self == Wallaby.configuration.mapping.model_authorizer
        @model_class ||= Map.model_class_map(name.gsub('Authorizer', EMPTY_STRING))
      end

      # @!attribute [w] provider_name
      attr_writer :provider_name

      # @!attribute [r] provider_name
      # Provider name of the authorization framework used
      # @return [String, Symbol] provider name
      # @return [nil] if assoicated provider name is not found
      def provider_name
        @provider_name ||= ModuleUtils.try_to superclass, :provider_name
      end
    end

    delegate(*ModelAuthorizationProvider.instance_methods(false), to: :@provider)

    # @!attribute [r] model_class
    # @return [Class]
    attr_reader :model_class

    # @param context [ActionController::Base]
    # @param model_class [Class]
    def initialize(context, model_class)
      @model_class = self.class.model_class || model_class
      @provider = init_provider context
    end

    protected

    # Go through provider list and detect which provider is used.
    # @param context [ActionController::Base]
    # @return [Wallaby::Authorizer]
    def init_provider(context)
      providers = Map.authorizer_provider_map model_class
      provider_class = providers[self.class.provider_name]
      provider_class ||= providers.values.find { |klass| klass.available? context }
      provider_class.new context
    end
  end
end
