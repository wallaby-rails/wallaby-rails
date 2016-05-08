class Wallaby::Mode
  INTERFACE_METHODS = %w( model_decorator model_finder model_servicer )

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

  def self.mode_map
    Rails.cache.fetch 'wallaby/mode_map' do
      {}.tap do |map|
        subclasses.each do |mode_class|
          mode_class.model_finder.new.available.each do |model_class|
            map[model_class] = mode_class
          end
        end
      end
    end
  end

  def self.model_classes(configuration = Wallaby.configuration)
    Rails.cache.fetch 'wallaby/model_classes' do
      models          = configuration.models
      full_list       = mode_map.keys
      configed_models = models.presence

      if configed_models
        invalid_models = configed_models - full_list
        if invalid_models.length > 0
          fail Wallaby::InvalidError, "#{ invalid_models.to_sentence } are invalid models."
        end
        configed_models
      else
        full_list - models.excludes
      end
    end
  end
end
