module Wallaby
  # @!visibility private
  # Url helper
  class UrlFor
    class << self
      # Handle wallaby engine url properly.
      # @param engine [ActionDispatch::Routing::RoutesProxy]
      # @param options [ActionController::Parameters, Hash]
      # @return [String] url string for wallaby engine
      def handle(engine, options)
        # NOTE: DEPRECATION WARNING: You are calling a `*_path` helper with the
        # `only_path` option explicitly set to `false`.
        # This option will stop working on path helpers in Rails 5.
        # Use the corresponding `*_url` helper instead.
        hash = normalize_params(options).except(:only_path)
        case hash[:action]
        when 'healthy' then engine.root_path hash
        when 'index', 'create' then engine.resources_path hash
        when 'show', 'update', 'destroy' then engine.resource_path hash
        when 'new' then engine.new_resource_path hash
        when 'edit' then engine.edit_resource_path hash
        when 'home' then engine.root_path hash
        when *Wallaby::ERRORS.map(&:to_s) then engine.public_send "#{hash[:action]}_path", hash
        else engine.url_for hash
        end
      end

      private

      # We will need to normalize params and return a hash
      # so that the url helper
      # could build up the url properly.
      # @param options [ActionController::Parameters, Hash]
      # @return [Hash]
      def normalize_params(options)
        return options unless options.is_a? ActionController::Parameters
        options.permit(:resources, :action, :id).to_h
      end
    end
  end
end
