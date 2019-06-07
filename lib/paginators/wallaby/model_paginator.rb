module Wallaby
  # Model paginator to provide support for pagination on index page
  class ModelPaginator
    extend Baseable::ClassMethods

    class << self
      # @!attribute [w] model_class
      attr_writer :model_class

      # @!attribute [r] model_class
      # Return associated model class, e.g. return **Product** for **ProductPaginator**.
      #
      # If Wallaby can't recognise the model class for Paginator, it's required to be configured as below example:
      # @example To configure model class
      #   class Admin::ProductPaginator < Admin::ApplicationPaginator
      #     self.model_class = Product
      #   end
      # @example To configure model class for version below 5.2.0
      #   class Admin::ProductPaginator < Admin::ApplicationPaginator
      #     def self.model_class
      #       Product
      #     end
      #   end
      # @return [Class] assoicated model class
      # @return [nil] if current class is marked as base class
      # @return [nil] if current class is the same as the value of {Wallaby::Configuration::Mapping#model_paginator}
      # @return [nil] if current class is {Wallaby::ModelPaginator}
      # @return [nil] if assoicated model class is not found
      def model_class
        return unless self < ModelPaginator
        return if base_class? || self == Wallaby.configuration.mapping.model_paginator
        @model_class ||= Map.model_class_map(name.gsub(/(^#{namespace}::)|(Paginator$)/, EMPTY_STRING))
      end

      # @!attribute provider_class
      # @return [Class] pagination provider class
      # @since 5.2.0
      attr_accessor :provider_class
    end

    # @!attribute [r] model_class
    # @return [Class]
    attr_reader :model_class

    # @!attribute [r] provider
    # @return [Wallaby::ModelServiceProvider]
    # @since 5.2.0
    attr_reader :provider

    # During initialization, Wallaby will assign a pagination provider for this paginator
    # to carry out the actual execution.
    #
    # Therefore, all its actions can be completely replaced by user's own implemnetation.
    # @param model_class [Class]
    # @param collection [#to_a] a collection of the resources
    # @param params [ActionController::Parameters]
    def initialize(model_class, collection, params)
      @model_class = self.class.model_class || model_class
      raise ArgumentError, I18n.t('errors.required', subject: 'model_class') unless @model_class
      @collection = collection
      @params = params
      @provider = Map.pagination_provider_map(@model_class).new(@collection, @params)
    end

    delegate(*ModelPaginationProvider.instance_methods(false), to: :provider)
    # @!method paginatable?
    #   (see Wallaby::ModelPaginationProvider#paginatable?)

    # @!method first_page?
    #   (see Wallaby::ModelPaginationProvider#first_page?)

    # @!method prev_page?
    #   (see Wallaby::ModelPaginationProvider#prev_page?)

    # @!method last_page?
    #   (see Wallaby::ModelPaginationProvider#last_page?)

    # @!method next_page?
    #   (see Wallaby::ModelPaginationProvider#next_page?)

    # @!method from
    #   (see Wallaby::ModelPaginationProvider#from)

    # @!method to
    #   (see Wallaby::ModelPaginationProvider#to)

    # @!method total
    #   (see Wallaby::ModelPaginationProvider#total)

    # @!method page_size
    #   (see Wallaby::ModelPaginationProvider#page_size)

    # @!method page_number
    #   (see Wallaby::ModelPaginationProvider#page_number)

    # @!method first_page_number
    #   (see Wallaby::ModelPaginationProvider#first_page_number)

    # @!method last_page_number
    #   (see Wallaby::ModelPaginationProvider#last_page_number)

    # @!method prev_page_number
    #   (see Wallaby::ModelPaginationProvider#prev_page_number)

    # @!method next_page_number
    #   (see Wallaby::ModelPaginationProvider#next_page_number)

    # @!method number_of_pages
    #   (see Wallaby::ModelPaginationProvider#number_of_pages)
  end
end
