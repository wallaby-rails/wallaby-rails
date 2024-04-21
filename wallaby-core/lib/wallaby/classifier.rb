# frozen_string_literal: true

module Wallaby
  # Concern to handle the conversion between Class and String
  module Classifier
    extend self

    # Convert Class to String. If not Class, unchanged.
    # @param klass [Object]
    # @return [String] if klass is not nil
    # @return [nil] if klass is nil or klass is an anonymous Class
    def class_name_of(klass)
      klass.is_a?(Class) ? klass.try(:name) : klass.try(:to_s)
    end

    # Convert String to Class. If not String, unchanged.
    # @param name [Object]
    # @return [Class] if name is a Class
    # @return [Object] if name is not a String
    # @return [nil] if class cannot be found
    def to_class(name, raising: Wallaby.configuration.raise_on_name_error)
      return name unless name.is_a?(String)
      # blank string will lead to NameError `wrong constant name`
      return if name.blank?

      # NOTE: DO NOT try to use `const_defined?` and `const_get` EVER.
      # Rails does all the class loading magics using `constantize`
      name.constantize
    rescue NameError => e
      raise if raising

      uninitialized = e.message.start_with?('uninitialized constant')
      raise unless uninitialized

      # block to handle this missing constant, e.g. use a default class or log useful instruction
      yield(name) if block_given?
    end
  end
end
