module Wallaby
  # Mode
  class Mode
    INTERFACE_METHODS =
      %w(model_decorator model_finder model_service_provider).freeze

    INTERFACE_METHODS.each do |method_id|
      define_singleton_method method_id do
        begin
          method_class  = __callee__.to_s.classify
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
end
