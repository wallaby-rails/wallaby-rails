module Wallaby
  # Model finder interface
  class ModelFinder
    # Need to implement this method to get all the available model for a mode
    # @return [Array<Class>] a list of model class
    def all
      raise NotImplemented
    end
  end
end
