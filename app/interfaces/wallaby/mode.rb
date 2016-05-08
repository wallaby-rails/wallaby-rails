class Wallaby::Mode
  INTERFACE_METHODS = %w( model_decorator model_finder model_operator )

  INTERFACE_METHODS.each do |method_id|
    define_singleton_method method_id do
      begin
        method_class  = __callee__.to_s.classify
        class_name    = "#{ name }::#{ method_class }"
        parent_class  = "Wallaby::#{ method_class }".constantize
        klass         = class_name.constantize

        fail Wallaby::InvalidError, "#{ klass } must inherit #{ parent_class }" unless klass < parent_class
      rescue NameError
        fail Wallaby::NotImplemented, class_name
      end
    end
  end
end
