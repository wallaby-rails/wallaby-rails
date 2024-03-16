# frozen_string_literal: true

module ControllerSupport
  extend ActiveSupport::Concern

  included do
    routes { ::Wallaby::Engine.routes }
  end
end

RSpec.configure do |config|
  config.include ControllerSupport, type: :controller

  config.before :each, type: :controller do |example|
    next unless controller

    controller.request.env['SCRIPT_NAME'] = example.metadata[:script_name] || '/admin'
    def controller.current_user; end unless controller.respond_to?(:current_user)
  end
end
