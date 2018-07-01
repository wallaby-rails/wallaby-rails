module Wallaby
  # Wallaby's application controller. It defaults to inherit from `::ApplicationController`,
  # which can be configured via `Wallaby.configuration.base_controller`
  #
  # Here, it contains one action `healthy` for health check, and contains the error handling logics.
  #
  # @!parse
  #   class Wallaby::ApplicationController < ::ApplicationController
  #   end
  class ApplicationController < configuration.base_controller
    helper ApplicationHelper

    ERROR_PATH = 'wallaby/error'.freeze
    ERROR_LAYOUT = ERROR_PATH

    rescue_from NotFound, with: :not_found
    rescue_from ::ActionController::ParameterMissing, with: :bad_request
    rescue_from ::ActiveRecord::StatementInvalid, with: :unprocessable_entity
    rescue_from UnprocessableEntity, with: :unprocessable_entity

    # Health check page
    def healthy
      render plain: 'healthy'
    end

    # Not found page. And it will be used for error handling as the action name implies.
    # @param exception [Exception, nil] exception comes from `rescue_from`
    def not_found(exception = nil)
      error_rendering(exception, __callee__)
    end

    # Bad request page. And it will be used for error handling as the action name implies.
    # @param exception [Exception, nil] exception comes from `rescue_from`
    def bad_request(exception = nil)
      error_rendering(exception, __callee__)
    end

    # Unprocessable entity page. And it will be used for error handling as the action name implies.
    # @param exception [Exception, nil] exception comes from `rescue_from`
    def unprocessable_entity(exception = nil)
      error_rendering(exception, __callee__)
    end

    # Internal server error page. And it will be used for error handling as the action name implies.
    # @param exception [Exception, nil] exception comes from `rescue_from`
    def internal_server_error(exception = nil)
      error_rendering(exception, __callee__)
    end

    delegate(*Wallaby::ConfigurationHelper.instance_methods, to: :helpers)

    protected

    # `helpers` exists since Rails 5, need to mimic this for Rails 4.2
    # @see https://github.com/rails/rails/blob/5-0-stable/actionpack/lib/action_controller/metal/helpers.rb#L118
    def helpers
      @helpers ||= defined?(super) ? super : view_context
    end

    # Capture exceptions and display the error using error layout and template.
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
