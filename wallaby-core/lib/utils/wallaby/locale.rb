# frozen_string_literal: true

module Wallaby
  # Locale related
  module Locale
    class << self
      # Extend translation just for Wallaby
      # so that translation can be prefixed with `wallaby.`
      # @param key [String, Symbol, Array]
      # @param options [Hash] the rest of the arguments
      # @return [String] translation
      def t(key, options = {})
        translator = options.delete(:translator) || I18n.method(:t)
        return translator.call(key, options) unless key.is_a?(String) || key.is_a?(Symbol)

        new_key, new_defaults = normalize key, options.delete(:default)

        translator.call(new_key, default: new_defaults, **options)
      end

      private

      # @param key [String, Symbol, Array]
      # @param defaults [String, Symbol, Array]
      # @return [Array]
      def normalize(key, defaults)
        *keys, default = *defaults

        # default will NOT be considered as one of the key
        # if it is not set or if it is a String (since String means translation for I18n.t)
        unless default.nil? || default.is_a?(String)
          keys << default
          default = nil
        end

        new_defaults = prefix_defaults_from keys.unshift(key)
        new_key = new_defaults.shift
        new_defaults << default if default
        [new_key, new_defaults]
      end

      # Duplicate and prefix the keys respectively
      # @param keys [Array]
      # @return [Array] new_keys
      def prefix_defaults_from(keys)
        keys.each_with_object([]) do |k, result|
          result << :"wallaby.#{k}" unless k.to_s.start_with? 'wallaby.'
          result << k.to_sym
        end
      end
    end
  end
end
