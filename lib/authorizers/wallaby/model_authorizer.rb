module Wallaby
  # Model Authorizer to provide authorization functions
  # @since 5.2.0
  class ModelAuthorizer
    extend Baseable::ClassMethods

    class << self
      # @!attribute [w] model_class
      attr_writer :model_class

      # @!attribute [r] model_class
      # Return associated model class, e.g. return **Product** for **ProductAuthorizer**.
      #
      # If Wallaby can't recognise the model class for Authorizer, it's required to be configured as below example:
      # @example To configure model class
      #   class Admin::ProductAuthorizer < Admin::ApplicationAuthorizer
      #     self.model_class = Product
      #   end
      # @example To configure model class for version below 5.2.0
      #   class Admin::ProductAuthorizer < Admin::ApplicationAuthorizer
      #     def self.model_class
      #       Product
      #     end
      #   end
      # @return [Class] assoicated model class
      # @return [nil] if current class is marked as base class
      # @return [nil] if current class is the same as the value of {Wallaby::Configuration::Mapping#model_authorizer}
      # @return [nil] if current class is {Wallaby::ModelAuthorizer}
      # @return [nil] if assoicated model class is not found
      def model_class
        return unless self < ModelAuthorizer
        return if base_class? || self == Wallaby.configuration.mapping.model_authorizer
        @model_class ||= Map.model_class_map(name.gsub(/(^#{namespace}::)|(Authorizer$)/, EMPTY_STRING))
      end

      # @!attribute [w] provider_name
      attr_writer :provider_name

      # @!attribute [r] provider_name
      # @return [String, Symbol] provider name of the authorization framework used
      def provider_name
        @provider_name ||= ModuleUtils.try_to superclass, :provider_name
      end

      # Factory method to create the model authorizer
      # @param context [ActionController::Base]
      # @param model_class [Class]
      # @return [Wallaby::ModelAuthorizer]
      def create(context, model_class)
        model_class ||= self.model_class
        provider_class = guess_provider_class context, model_class
        new model_class, provider_class, provider_class.args_from(context)
      end

      private

      # @param context [ActionController::Base]
      # @param model_class [Class]
      # @return [Class] provider class
      def guess_provider_class(context, model_class)
        providers = Map.authorizer_provider_map model_class
        providers[provider_name] || providers.values.find { |klass| klass.available? context }
      end
    end

    delegate(*ModelAuthorizationProvider.instance_methods(false), to: :@provider)

    # @!attribute [r] model_class
    # @return [Class]
    attr_reader :model_class

    # @!attribute [r] provider
    # @return [Wallaby::ModelAuthorizationProvider]
    # @since 5.2.0
    attr_reader :provider

    # @param model_class [Class]
    # @param provider_name_or_class [String, Symbol, Class]
    # @param options [Hash]
    def initialize(model_class, provider_name_or_class, options = {})
      @model_class = model_class || self.class.model_class
      @provider = init_provider provider_name_or_class, options
    end

    protected

    # Go through provider list and detect which provider is used.
    # @param provider_name_or_class [String, Symbol, Class]
    # @param options [Hash]
    # @return [Wallaby::Authorizer]
    def init_provider(provider_name_or_class, options)
      providers = Map.authorizer_provider_map model_class
      provider_class = provider_name_or_class.is_a?(Class) ? provider_name_or_class : providers[provider_name_or_class]
      provider_class.new(**options)
    end
  end
end
