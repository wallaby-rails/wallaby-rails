# frozen_string_literal: true

module Wallaby
  class Configuration
    class Constraints
      # @see see https://stackoverflow.com/a/38191078
      DEFAULT_ID =
        /
          (
            # only digits
            (?=(\d+))\d+|
            # only uuid
            (?=(
              [0-9A-Fa-f]{8}-[0-9A-Fa-f]{4}-[1-5][0-9A-Fa-f]{3}-[89ABab][0-9A-Fa-f]{3}-[0-9A-Fa-f]{12}
            ))[0-9A-Fa-f-]{36}
          )
        /x.freeze

      DEFAULT_RESOURCES =
        %r{
          (?!.+__) # string contains no double underscore
          [a-zA-Z][0-9a-zA-Z_]*(?<!_) # string starts with alphabet but not ends with underscore
          ((/|::)[a-zA-Z][0-9a-zA-Z_]*(?<!_))* # repeating strings begin with slash or double colons
        }x.freeze

      # @!attribute [w] id
      attr_writer :id

      # @!attribute [r] id
      def id
        @id ||= DEFAULT_ID
      end

      # @!attribute [w] resources
      attr_writer :resources

      # @!attribute [r] resources
      def resources
        @resources ||= DEFAULT_RESOURCES
      end
    end
  end
end
