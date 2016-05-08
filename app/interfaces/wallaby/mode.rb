class Wallaby::Mode
  INTERFACE_METHODS = %w( model_decorator model_finder model_operator )

  INTERFACE_METHODS.each do |method_id|
    define_singleton_method method_id do
      begin
        method_class  = __callee__.to_s.classify
        klass_name    = "#{ name }::#{ method_class }"
        klass_name.constantize
      rescue NameError
        fail Wallaby::NotImplemented, klass_name
      end
    end
  end
end
