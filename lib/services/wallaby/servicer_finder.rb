class Wallaby::ServicerFinder
  def self.find(model_class)
    Wallaby::Map.servicer_map[model_class] || Wallaby::ModelServicer
  end
end
