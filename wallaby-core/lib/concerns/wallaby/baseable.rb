# frozen_string_literal: true

module Wallaby
  # Abstract related class methods
  module Baseable
    extend ActiveSupport::Concern

    # Configurable attributes:
    # 1. mark a class as a base class
    # 2. guess the model class if model class isn't given
    module ClassMethods
      # @return [true] if class is a base class
      # @return [false] if class is not a base class
      def base_class?
        @base_class == self
      end

      # Mark the current class as the base class
      def base_class!
        @base_class = self
      end

      # @!attribute [r] base_class
      # @return [Class] The base class or the one from super class
      def base_class
        @base_class || superclass.try(:base_class)
      end

      # @!attribute [w] model_class
      def model_class=(model_class)
        raise ArgumentError 'Please provide a Class for `model_class`.' unless model_class.is_a? Class

        @model_class = model_class
      end

      # @!attribute [r] model_class
      # @example To configure the model class
      #   class Admin::ProductAuthorizer < Admin::ApplicationAuthorizer
      #     self.model_class = Product
      #   end
      # @example To configure the model class for version below 5.2.0
      #   class Admin::ProductAuthorizer < Admin::ApplicationAuthorizer
      #     def self.model_class
      #       Product
      #     end
      #   end
      # @return [Class] assigned model class or Wallaby will guess it
      #   (see {Guesser.class_for})
      # @return [nil] if current class is marked as base class
      # @raise [ClassNotFound] if model class isn't found
      # @raise [ArgumentError] if base class is empty
      def model_class
        return if base_class?

        @model_class ||= Guesser.class_for(name) || raise(
          ClassNotFound, <<~INSTRUCTION
            The `model_class` hasn't been provided for Class `#{name}` and Wallaby cannot guess it right.
            If `#{name}` is supposed to be a base class, add the following line to its class declaration:

              class #{name}
                base_class!
              end

            Otherwise, please specify the `model_class` in `#{name}`'s declaration as follows:

              class #{name}
                self.model_class = CorrectModelClass
              end
          INSTRUCTION
        )
      end

      # @deprecated
      def namespace=(_namespace)
        Deprecator.alert method(__callee__), from: '0.3.0'
      end

      # @deprecated
      def namespace
        Deprecator.alert method(__callee__), from: '0.3.0'
      end
    end
  end
end
