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
end