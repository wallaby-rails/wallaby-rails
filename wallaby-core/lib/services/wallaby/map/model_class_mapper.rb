# frozen_string_literal: true

module Wallaby
  class Map
    # Go through the class list and generate a {.map .map} that uses the class's model_class as the key.
    class ModelClassMapper
      # @param class_array [Array<Class>]
      # @return [ClassHash] model class => descendant class
      def self.map(class_array)
        (class_array || EMPTY_ARRAY).each_with_object(ClassHash.new) do |klass, hash|
          next if ModuleUtils.anonymous_class?(klass)
          next if klass.try(:base_class?) || klass.model_class.blank?

          hash[klass.model_class] = block_given? ? yield(klass) : klass
        end
      end
    end
  end
end
