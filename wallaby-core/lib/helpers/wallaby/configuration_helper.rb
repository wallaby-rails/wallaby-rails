# frozen_string_literal: true

module Wallaby
  # Configuration helper module. Provide shortcut methods to configurations.
  module ConfigurationHelper
    delegate :max_text_length, to: :wallaby_controller

    # @return [Configuration] shortcut method of configuration
    def configuration
      Wallaby.configuration
    end

    # @deprecated
    def default_metadata
      Deprecator.alert 'default_metadata.max', from: '0.3.0', alternative: <<~INSTRUCTION
        Please use `max_text_length` instead
      INSTRUCTION
    end

    # @deprecated
    def mapping
      Deprecator.alert method(__callee__), from: '0.3.0'
    end

    # @deprecated
    def security
      Deprecator.alert method(__callee__), from: '0.3.0'
    end

    # @deprecated
    def models
      Deprecator.alert method(__callee__), from: '0.3.0'
    end

    # @deprecated
    def pagination
      Deprecator.alert method(__callee__), from: '0.3.0'
    end

    # @deprecated
    def features
      Deprecator.alert method(__callee__), from: '0.3.0'
    end

    # @deprecated
    def sorting
      Deprecator.alert method(__callee__), from: '0.3.0'
    end
  end
end
