# frozen_string_literal: true

require_relative '../application_generator'

module Wallaby
  class Engine
    # `wallaby:engine:servicer` generator
    # @see https://github.com/wallaby-rails/wallaby-core/blob/master/lib/generators/wallaby/engine/servicer/USAGE
    class ServicerGenerator < ApplicationGenerator
      source_root File.expand_path('templates', __dir__)

      protected

      def base_name
        'servicer'
      end
    end
  end
end
