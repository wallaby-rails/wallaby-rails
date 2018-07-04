module Wallaby
  # Utils for url
  module EngineUtils
    # Use script name to find out the corresponding route and its engine name
    # @param env [Hash]
    # @return [String] engine name
    def self.engine_name_from(env)
      script_name = env[SCRIPT_NAME]
      return EMPTY_STRING if script_name.blank?
      named_route = Rails.application.routes.routes.find { |route| route.path.match(script_name) }
      named_route.try(:name) || EMPTY_STRING
    end
  end
end
