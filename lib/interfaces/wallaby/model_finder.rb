module Wallaby
  # Model finder interface
  class ModelFinder
    # Need to implement this method to get all the available model for a mode
    def all
      raise NotImplemented
    end
  end
end
