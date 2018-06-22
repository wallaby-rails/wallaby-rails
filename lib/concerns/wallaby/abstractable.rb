module Wallaby
  # Class attributes and methods for controller
  module Abstractable
    extend ActiveSupport::Concern

    class_methods do
      # @return [Boolean] abstract or not
      def abstract
        @abstract ||= false
      end

      # Mark the class abstract
      # @return [Boolean] true
      def abstract!
        @abstract = true
      end
    end
  end
end
