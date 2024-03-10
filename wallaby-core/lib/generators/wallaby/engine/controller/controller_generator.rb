# frozen_string_literal: true

require_relative '../application_generator'

module Wallaby
  class Engine
    # `wallaby:engine:controller` generator
    # @see https://github.com/wallaby-rails/wallaby-core/blob/master/lib/generators/wallaby/engine/controller/USAGE
    class ControllerGenerator < ApplicationGenerator
      source_root File.expand_path('templates', __dir__)

      protected

      def application_class
        Wallaby.configuration.resources_controller
      end

      def base_name
        'controller'
      end
    end
  end
end
