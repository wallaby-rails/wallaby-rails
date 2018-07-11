module Wallaby
  # Service object to find the engine name
  class EngineNameFinder
    class << self
      # Use script name to find out the corresponding named route and its engine name
      # @param env [Hash, String] request env or script name
      # @return [String] engine name or empty string if not found
      def find(env)
        script_name = env[SCRIPT_NAME] if env.is_a? Hash
        script_name = env if env.is_a? String
        return EMPTY_STRING if script_name.blank?
        named_route = Rails.application.routes.routes.find { |route| route.path.match(script_name) }
        named_route.try(:name) || EMPTY_STRING
      end
    end
  end
end
