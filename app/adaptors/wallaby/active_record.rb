module Wallaby::ActiveRecord
  def self.model_decorator
    ModelDecorator
  end

  def self.model_finder
    ModelFinder
  end

  def self.resource_commander
    ResourceCommander
  end
end
