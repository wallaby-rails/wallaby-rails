# frozen_string_literal: true

module Wallaby
  class Custom
    # Model finder for {Custom} mode that returns the list of model set by
    # {Wallaby::Configuration#custom_models}
    class ModelFinder < ::Wallaby::ModelFinder
      # @return [ClashArray] a list of classes
      def all
        Wallaby.configuration.custom_models
      end
    end
  end
end
