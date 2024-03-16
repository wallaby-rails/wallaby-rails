# frozen_string_literal: true

RSpec.configure do |config|
  config.before do
    Wallaby.configuration.resources_controller.try(:clear)
    Wallaby.configuration.clear
    Wallaby::Map.clear
    Wallaby::ModelAuthorizer.provider_name = nil
  end

  config.around :suite do |example|
    Wallaby.configuration.resources_controller.try(:clear)
    Wallaby.configuration.clear
    Wallaby::Map.clear
    Wallaby::ModelAuthorizer.provider_name = nil
    const_before = Object.constants
    example.run
    const_after = Object.constants
    (const_after - const_before).each do |const|
      Object.send :remove_const, const
    end

    Wallaby.configuration.resources_controller.try(:clear)
    Wallaby.configuration.clear
    Wallaby::Map.clear
  end
end
