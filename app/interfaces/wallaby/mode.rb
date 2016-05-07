class Wallaby::Mode
  INTERFACE_METHODS = %w( model_decorator model_finder model_servicer )

  INTERFACE_METHODS.each do |method_id|
    define_singleton_method method_id do
      klass = "#{ name }::#{ __callee__.to_s.classify }"
      klass.constantize rescue fail Wallaby::NotImplemented, klass
    end
  end
end
