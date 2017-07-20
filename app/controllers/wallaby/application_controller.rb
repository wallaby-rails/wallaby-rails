module Wallaby
  # Wallaby's application controller.
  # Default to inherit from ::ApplicationController
  # It is responsible for handling exceptions
  class ApplicationController < configuration.base_controller
    helper ApplicationHelper

    ERROR_PATH = 'wallaby/error'.freeze

    rescue_from NotFound, with: :not_found
    rescue_from ::ActionController::ParameterMissing, with: :bad_request
    rescue_from ::ActiveRecord::StatementInvalid, with: :unprocessable_entity

    layout 'wallaby/application'

    protected

    def configuration
      ::Wallaby.configuration
    end

    def not_found(exception = nil)
      error_rendering(exception, __callee__)
    end

    def bad_request(exception)
      error_rendering(exception, __callee__)
    end

    def unprocessable_entity(exception)
      error_rendering(exception, __callee__)
    end

    def error_rendering(exception, symbol)
      @exception = exception
      @symbol = symbol
      @code = Rack::Utils::SYMBOL_TO_STATUS_CODE[@symbol].to_i

      Rails.logger.error @exception
      render ERROR_PATH, layout: ERROR_PATH, status: symbol
    end
  end
end
