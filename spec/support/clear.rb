# frozen_string_literal: true

RSpec.configure do |config|
  config.before do
    Wallaby.configuration.resources_controller.try(:clear)
    Wallaby.configuration.clear
    Wallaby::Map.clear
    Wallaby::ModelAuthorizer.provider_name = nil
  end
end
