# frozen_string_literal: true

module Wallaby
  # This is the base authorizer class to provider authorization for given/associated model.
  #
  # For best practice, please create an application authorizer class (see example)
  # to better control the functions shared between different model authorizers.
  # @example Create an application class for Admin Interface usage
  #   class Admin::ApplicationAuthorizer < Wallaby::ModelAuthorizer
  #     base_class!
  #   end
  # @since wallaby-5.2.0
  class ModelAuthorizer
    extend Baseable::ClassMethods
    base_class!

    class << self
      # @!attribute [w] provider_name
      attr_writer :provider_name

      # @!attribute [r] provider_name
      # Provider name of the authorization framework used.
      # It will be inherited from its parent classes if there isn't one for current class.
      # @return [String, Symbol]
      def provider_name
        @provider_name || superclass.try(:provider_name)
      end
    end

    delegate(*ModelAuthorizationProvider.instance_methods(false), to: :@provider)

    # @!attribute [r] model_class
    # @return [Class]
    attr_reader :model_class

    # @!attribute [r] provider
    # @return [ModelAuthorizationProvider] the instance that does the job
    # @since wallaby-5.2.0
    attr_reader :provider

    # @!attribute [r] context
    # @return [ActionController::Base, ActionView::Base, nil]
    # @since 0.2.2
    attr_reader :context

    # @!attribute [r] options
    # @return [Hash]
    # @since 0.2.2
    attr_reader :options

    # @note use this method instead of {#initialize} to create authorizer instance
    # Factory method to determine which provider and what options to use.
    # @param model_class [Class]
    # @param context [ActionController::Base, ActionView::Base]
    def self.create(model_class, context)
      model_class ||= self.model_class
      provider_class = guess_and_set_provider_from(model_class, context)
      options = provider_class.options_from(context)
      new(model_class, provider: provider_class.new(options), context: context)
    end

    # Shortcut of {Map.authorizer_provider_map}
    def self.providers_of(model_class)
      Map.authorizer_provider_map(model_class)
    end

    # @param model_class [Class]
    # @param provider_name [String]
    # @param provider [Wallaby::ModelAuthorizationProvider]
    # @param context [ActionController::Base, ActionView::Base]
    # @param options [Hash]
    def initialize(
      model_class,
      provider_name: nil,
      provider: nil,
      context: nil,
      options: {}
    )
      @model_class = model_class || self.class.model_class
      @options = options
      @context = context
      @provider = provider \
        || self.class.providers_of(@model_class)[provider_name].new(options)
    end

    # Go through the provider list and find out the one is
    # {Wallaby::ModelAuthorizationProvider.available? .available?}
    # @param model_class [Class]
    # @param context [ActionController::Base, ActionView::Base]
    # @return [Class] provider class
    def self.guess_and_set_provider_from(model_class, context)
      providers = providers_of(model_class)
      provider_class =
        providers[provider_name] \
          || providers.values.find { |klass| klass.available? context } \
          || providers[:default] # fallback to default
      self.provider_name ||= provider_class.provider_name
      provider_class
    end
  end
end
