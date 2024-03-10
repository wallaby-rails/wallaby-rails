# frozen_string_literal: true

require_relative '../application_generator'

module Wallaby
  class Engine
    # `wallaby:engine:decorator` generator
    # @see https://github.com/wallaby-rails/wallaby-core/blob/master/lib/generators/wallaby/engine/decorator/USAGE
    class DecoratorGenerator < ApplicationGenerator
      source_root File.expand_path('templates', __dir__)

      protected

      def base_name
        'decorator'
      end
    end
  end
end
