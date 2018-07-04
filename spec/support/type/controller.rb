module Wallaby
  module RSpec
    module ControllerRoutes
      extend ActiveSupport::Concern
      included do
        routes { ::Wallaby::Engine.routes }
      end
    end
  end
end

RSpec.configure do |config|
  config.include Wallaby::RSpec::ControllerRoutes, type: :controller

  config.before :each, type: :controller do |example|
    controller.request.env['SCRIPT_NAME'] = example.metadata[:script_name] || '/admin'
  end
end
