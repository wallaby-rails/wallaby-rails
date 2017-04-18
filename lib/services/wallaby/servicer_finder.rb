module Wallaby
  # Servicer finder
  class ServicerFinder
    # TODO: rework on this
    def self.find(model_class)
      Wallaby::Map.servicer_map[model_class] || Wallaby::ModelServicer
    end
  end
end
