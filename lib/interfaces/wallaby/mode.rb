module Wallaby
  # This is the abstract class that all ORM modes to have implemented.
  class Mode
    class << self
      # @see Wallaby::ModelDecorator
      # @return [Wallaby::ModelDecorator] model decorator for the mode
      def model_decorator
        check_and_constantize __callee__
      end

      # @see Wallaby::ModelFinder
      # @return [Wallaby::ModelFinder] model finder for the mode
      def model_finder
        check_and_constantize __callee__
      end

      # @see Wallaby::ModelServiceProvider
      # @return [Wallaby::ModelServiceProvider] service provider for the mode
      def model_service_provider
        check_and_constantize __callee__
      end

      # @see Wallaby::ModelPaginationProvider
      # @return [Wallaby::ModelPaginationProvider]
      # pagination provider for the mode
      def model_pagination_provider
        check_and_constantize __callee__
      end

      private

      #
      # @return [Class] constantized class
      def check_and_constantize(method_id)
        method_class  = method_id.to_s.classify
        class_name    = "#{name}::#{method_class}"
        parent_class  = "Wallaby::#{method_class}".constantize
        class_name.constantize.tap do |klass|
          next if klass < parent_class
          raise InvalidError, "#{klass} must inherit #{parent_class}"
        end
      rescue NameError
        raise NotImplemented, class_name
      end
    end
  end
end
