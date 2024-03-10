# frozen_string_literal: true

module Wallaby
  class Map
    # Go through each {Mode} (e.g. **ActiveRecord**/**Her**)
    # and find out all the model classes respectively.
    # Then a hash (Model => {Mode}) is constructed
    # to tell {Wallaby} which {Mode} to use for a given model.
    class ModeMapper
      extend Classifier

      # @param class_names [ClassArray] mode class names
      # @return [WallabyClassHash]
      def self.execute(class_names)
        ClassHash.new.tap do |hash|
          next if class_names.blank?

          class_names.each_with_object(hash) do |mode_name, map|
            mode_name.model_finder.new.all.each do |model_class| # rubocop:disable Rails/FindEach
              map[model_class] = mode_name
            end
          end
        end
      end
    end
  end
end
