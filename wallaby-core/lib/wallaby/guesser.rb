# frozen_string_literal: true

module Wallaby
  # Guess the associated class for give class
  class Guesser
    SUFFIX = /(Controller|Decorator|Servicer|Authorizer|Paginator)$/.freeze # :no_doc:

    class << self
      # Find out the first demodulized class constant for the give class name.
      # For example, if given class name is **Admin::Order::ItemsController**,
      # then it will try to constantize the following demodulized class names
      # and return the first one that is successfully constantized:
      #
      # - Admin::Order::Item
      # - Order::Item
      # - Item
      # @param class_name [String]
      # @param options [Hash]
      # @return [Class] found associated class
      # @return [nil] if not found
      def class_for(class_name, options = {}, &block)
        suffix = options[:suffix] || EMPTY_STRING
        replacement = options[:replacement] || SUFFIX
        denamespace = options.key?(:denamespace) ? options[:denamespace] : true
        base_name = class_name.gsub(replacement, EMPTY_STRING).singularize << suffix
        possible_class_from(base_name, denamespace: denamespace, &block)
      end

      def possible_class_from(class_name, denamespace: false)
        target = nil
        parts = denamespace ? class_name.split(COLONS) : [class_name]
        parts.each_with_index.find do |_, index|
          klass = Classifier.to_class(parts[index..].join(COLONS))
          next unless klass
          # additional checking, the given block should return true to continue
          next if block_given? && !yield(klass)

          target = klass
        end

        target
      end
    end
  end
end
