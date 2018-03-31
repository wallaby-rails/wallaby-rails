module Wallaby
  # Wallaby's application controller
  # It defaults to inherit from ::ApplicationController, which can be configured
  # via `Wallaby.configuration.base_controller`
  # It only contains the error handling logics
  class ApplicationController < configuration.base_controller
    helper ApplicationHelper

    ERROR_PATH = ERROR_LAYOUT = 'wallaby/error'.freeze

    rescue_from NotFound, with: :not_found
    rescue_from ::ActionController::ParameterMissing, with: :bad_request
    rescue_from ::ActiveRecord::StatementInvalid, with: :unprocessable_entity
    rescue_from UnprocessableEntity, with: :unprocessable_entity

    layout 'wallaby/application'

    # Not found page
    # @param exception [Exception]
    def not_found(exception = nil)
      error_rendering(exception, __callee__)
    end

    # Bad request page
    # @param exception [Exception]
    def bad_request(exception = nil)
      error_rendering(exception, __callee__)
    end

    # Unprocessable entity page
    # @param exception [Exception]
    def unprocessable_entity(exception = nil)
      error_rendering(exception, __callee__)
    end

    # @return [Wallaby::Configuration] global configuration
    def self.configuration
      ::Wallaby.configuration
    end

    # @return [Wallaby::Configuration] global configuration
    def configuration
      self.class.configuration
    end

    protected

    # @see https://github.com/rails/rails/blob/5-0-stable/actionpack/lib/action_controller/metal/helpers.rb#L118
    # `helpers` exists since Rails 5, need to replicate this for Rails 4.2
    def helpers
      @helpers ||= defined?(super) ? super : view_context
    end

    # capture exceptions and display the error using error layout and view
    # @param exception [Exception]
    # @param symbol [Symbol] http status symbol
    def error_rendering(exception, symbol)
      @exception = exception
      @symbol = symbol
      @code = Rack::Utils::SYMBOL_TO_STATUS_CODE[@symbol].to_i

      Rails.logger.error @exception
      render ERROR_PATH, layout: ERROR_LAYOUT, status: symbol
    end
  end
end
