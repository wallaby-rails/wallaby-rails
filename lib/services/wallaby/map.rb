class Wallaby::Map
  def self.mode_map(modes = nil)
    Rails.cache.fetch 'wallaby/mode_map' do
      {}.tap do |map|
        (modes || Wallaby::Mode.subclasses).each do |mode_class|
          mode_class.model_finder.new.all.each do |model_class|
            map[model_class] = mode_class
          end
        end
      end
    end
  end

  def self.model_classes(configuration = nil)
    Rails.cache.fetch 'wallaby/model_classes' do
      models          = (configuration || Wallaby.configuration).models
      full_list       = mode_map.keys
      configed_models = models.presence

      return full_list - models.excludes unless configed_models

      invalid_models = configed_models - full_list
      if invalid_models.length > 0
        fail Wallaby::InvalidError, "#{ invalid_models.to_sentence } are invalid models."
      end
      configed_models
    end
  end

  def self.controller_map
    Rails.cache.fetch 'wallaby/controller_map' do
      {}.tap do |map|
        Wallaby::ResourcesController.subclasses
        .reject{ |klass| klass.name.blank? }
        .each do |klass|
          map[klass.model_class] = klass
        end
      end
    end
  end
end
