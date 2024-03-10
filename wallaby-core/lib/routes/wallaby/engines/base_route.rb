# frozen_string_literal: true

module Wallaby
  module Engines
    class BaseRoute
      include ActiveModel::Model

      # @!attribute context
      # @return [ActionController::Base, ActionView::Base]
      attr_accessor :context
      # @!attribute params
      # @return [Hash, ActionController::Parameters]
      attr_accessor :params
      # @!attribute params
      # @return [Hash, ActionController::Parameters]
      attr_accessor :options

      protected

      # @param route [ActionDispatch::Journey::Route]
      def params_for(route)
        # ensure all required keys (e.g. `id`) are included
        required_params_from_recall = recall.slice(*route.required_keys)
        required_resources_name =
          route.required_keys.include?(:resources) ? { resources: resources_name } : {}

        route
          .requirements
          .merge(required_params_from_recall)
          .merge(required_resources_name)
          .merge(complete_params)
      end

      # @return [String] given action param or current request's action
      def action_name
        @action_name ||= (params[:action] || recall[:action]).try(:to_s)
      end

      # @return [Class] model class option or converted model class from recall resources name
      def model_class
        @model_class ||= options[:model_class] || Map.model_class_map(resources_name)
      end

      # @return [String] resources name for given model
      def resources_name
        @resources_name ||=
          params[:resources] ||
          (options[:model_class] && Inflector.to_resources_name(options[:model_class])) ||
          recall[:resources]
      end

      # Recall is the path params of current request
      # @see https://github.com/rails/rails/blob/master/actionpack/lib/action_controller/metal/url_for.rb#L35
      # @return [Hash]
      def recall
        @recall ||= context.url_options[:_recall] || {}
      end

      # @return [Hash] query params from the request path
      def with_query_params
        options[:with_query] ? context.request.query_parameters : {}
      end

      # Symbolize param keys and normalize action
      # @return [Hash]
      def normalize_params(*args)
        ParamsUtils
          .presence(*args)
          .deep_symbolize_keys
          .tap do |normalized_params|
            # convert :action (e.g. 'index') to string for requirements comparison
            # :action value in route requirements is string (e.g. action: 'index')
            normalized_params[:action] = action_name
          end
      end
    end
  end
end
