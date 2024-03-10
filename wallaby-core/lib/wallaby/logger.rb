# frozen_string_literal: true

module Wallaby
  # Custom logger
  module Logger
    class << self
      %i[unknown fatal error warn info debug].each do |method_id|
        define_method method_id do |message, replacements = {}|
          sourcing = replacements.delete(:sourcing) # sourcing can be set to false
          heading = replacements.delete(:heading) || 'WALLABY '
          new_message, from = normalize(
            message, (sourcing != false && Array.wrap(caller[sourcing || 0])) || nil
          )
          Wallaby.configuration.logger.try(
            method_id,
            "#{heading}#{method_id.to_s.upcase}: #{format new_message, replacements}#{from}"
          )
          nil
        end
      end

      # @param key [Symbol,String]
      # @param message_or_config [String, false]
      # @param replacements [Hash]
      # @example to disable a particular hint message:
      #   Wallaby::Logger.hint(:customize_controller, false) if Wallaby::Logger.debug?
      def hint(key, message_or_config, replacements = {})
        @hint ||= {}
        return @hint[key] = false if message_or_config == false
        return if @hint[key] == false || !message_or_config.is_a?(String)

        new_message = <<~MESSAGE
          #{message_or_config}
          This kind of debug message can be disabled in `config/initializers/wallaby.rb`:

            Wallaby::Logger.hint(#{key.inspect}, false) if Wallaby::Logger.debug?
        MESSAGE
        debug(new_message, replacements.merge(sourcing: false))
      end

      protected

      # @param message [String,StandardError,Object]
      # @param sources [Array<String>] array of files
      def normalize(message, sources)
        if message.is_a?(StandardError)
          return [
            message.message,
            sources && "\n#{message.backtrace.join("\n")}"
          ]
        end

        [message.to_s, sources && "\nfrom #{sources.join("     \n")}"]
      end
    end
  end
end
