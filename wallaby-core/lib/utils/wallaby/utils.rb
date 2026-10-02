# frozen_string_literal: true

module Wallaby
  module Utils # :nodoc:
    # @param object [Object]
    # @return [Object] a cloned object
    def self.clone(object)
      # NOTE: Neither marshal/deep_dup/dup is able to make a correct deep copy,
      # therefore, this is our solution:
      case object
      when Hash
        HashCloner.execute(object)
      when Array
        object.each_with_object(object.class.new) { |value, array| array << clone(value) }
      when Class
        # NOTE: `Class.dup` turns the origin Class object into an anonymous clone.
        # therefore, the Class object itself should be returned instead
        object
      else
        object.dup
      end
    end

    # @param object [Object, nil]
    # @return [String] inspection string for the given object
    def self.inspect(object)
      return 'nil' if object.nil?
      return "#{object.class}##{object.try(:id)}" if object.is_a?(::ActiveRecord::Base)

      object.inspect
    end

    # Status names Rack has since renamed and removed from
    # `Rack::Utils::SYMBOL_TO_STATUS_CODE` (e.g. `:unprocessable_entity` became
    # `:unprocessable_content` in Rack 3.2). Wallaby keeps its historical names
    # for routes and locale keys, so it resolves them here rather than through
    # Rack's deprecated, warning-emitting `status_code`.
    # NOTE: Rack keeps its own obsolete-symbol map private, and reading it would
    # both couple us to its internals and break Rack < 3.1 (where it is absent),
    # so only the names Wallaby itself uses are listed.
    OBSOLETE_STATUS_CODES = { unprocessable_entity: 422 }.freeze

    # @param symbol [Symbol] a Rack status name, e.g. a member of {Wallaby::ERRORS}
    # @return [Integer] HTTP status code
    # @raise [KeyError] if the status name is unknown to Rack
    def self.status_code(symbol)
      Rack::Utils::SYMBOL_TO_STATUS_CODE[symbol] || OBSOLETE_STATUS_CODES.fetch(symbol)
    end

    # Service object to clone Hash
    class HashCloner
      def self.execute(object)
        # NOTE: `default`/`default_proc` should be cloned as well
        default_method = object.default_proc ? :default_proc : :default
        object
          .each_with_object(object.class.new) { |(key, value), hash| hash[key] = Utils.clone(value) }
          .tap { |hash| hash.try("#{default_method}=", object.try(default_method)) }
      end
    end
  end
end
