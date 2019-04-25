module Wallaby
  class Custom
    # Model finder
    class ModelFinder < ::Wallaby::ModelFinder
      # @return [Array<Class>] a list of classes
      def all
        Wallaby.configuration.custom_models.presence
      end
    end
  end
end
