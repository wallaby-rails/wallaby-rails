# frozen_string_literal: true

module Wallaby
  # Concern to handle the conversion between Class and String
  module Classifier
    extend self

    # Convert Class to String. If not Class, unchanged.
    # @param klass [Object]
    # @return [String] if klass is a Class
    # @return [Object] if klass is not a Class
    def class_name_of(klass)
      klass.try(:name) || klass || nil
    end

    # Convert String to Class. If not String, unchanged.
    # @param name [Object]
    # @return [Class] if name is a Class
    # @return [Object] if name is not a String
    # @return [nil] if class cannot be found
    def to_class(name)
      return name unless name.is_a? String

      # NOTE: DO NOT try to use const_defined? and const_get EVER.
      # This is Rails, use constantize
      name.constantize
    rescue NameError
      yield(name) if block_given?
    end
  end
end
