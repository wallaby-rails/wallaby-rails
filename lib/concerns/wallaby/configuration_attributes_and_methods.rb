module Wallaby
  # Class attributes and methods for resources controller
  module ConfigurationAttributesAndMethods
    extend ActiveSupport::Concern

    # Class method for Confiurable concern
    module ClassMethods
      # @!attribute model_authorizer
      #   This attribute will be used for `current_model_authorizer`
      attr_accessor :model_authorizer

      # @!attribute [w] application_authorizer
      # @see .application_authorizer
      attr_writer :application_authorizer

      # @!attribute [r] application_authorizer
      #   @return [Class, nil]
      def application_authorizer
        @application_authorizer ||= from_superclass __callee__
      end

      private

      # @param method [Symbol, String]
      def from_superclass(method)
        superclass.respond_to?(method) && superclass.send(method) || nil
      end
    end
  end
end
