module Wallaby
  class Map
    # To generate a hash map (`model` => `mode`).
    # This will be used to tell if a model can be handled by Wallaby
    class ModeMapper
      # @param mode_classes [Array<Class>] model classes
      def initialize(mode_classes)
        @mode_classes = mode_classes
      end

      # This will walk through each mode (e.g. **ActiveRecord**/**Her**) then pull out all the models,
      # and then form a hash of (`model` => `mode`).
      # @return [Hash] { model_class => mode }
      def map
        return {} if @mode_classes.blank?
        @mode_classes.each_with_object({}) do |mode_class, map|
          mode_class.model_finder.new.all.each do |model_class|
            map[model_class] = mode_class
          end
        end
      end
    end
  end
end
