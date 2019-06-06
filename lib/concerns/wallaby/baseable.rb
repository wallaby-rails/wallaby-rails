module Wallaby
  # Abstract related class methods
  module Baseable
    # Configurable attributes and class methods for marking a class the base class
    # and skipping {Wallaby::Map Wallaby mapping}
    module ClassMethods
      # @return [true] if class is a base class
      # @return [false] if class is not a base class
      def base_class?
        @base_class ||= false
      end

      # Mark class a base class
      # @return [true]
      def base_class!
        @base_class = true
      end

      # @!attribute [w] namespace
      # Used by `model_class`
      attr_writer :namespace

      # @!attribute [r] namespace
      # @return [String] namespace
      def namespace
        @namespace ||=
          ModuleUtils.try_to(superclass, :namespace) \
          || name.deconstantize.gsub(/Wallaby(::)?/, EMPTY_STRING).presence
      end
    end
  end
end
