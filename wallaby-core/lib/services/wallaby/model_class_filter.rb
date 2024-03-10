# frozen_string_literal: true

module Wallaby
  # Fitler the model classes using
  class ModelClassFilter
    class << self
      # @param all [Array<Class>]
      # @param allowlisted [Array<Class>]
      # @param denylisted [Array<Class>]
      def execute(all:, allowlisted:, denylisted:)
        invalid, valid =
          allowlisted.present? ? [allowlisted - all, allowlisted] : [denylisted - all, all - denylisted]
        return valid if invalid.blank?

        raise InvalidError, <<~INSTRUCTION
          Wallaby can't handle these models: #{invalid.map(&:name).to_sentence}.
          If it's set via controller_class.models= or controller_class.models_to_exclude=,
          please remove them from the list.

          Or they can be added to Custom model list as below, and custom implementation will be required:

            Wallaby.config do |config|
              config.custom_models = #{invalid.map(&:name).join ', '}
            end
        INSTRUCTION
      end
    end
  end
end
