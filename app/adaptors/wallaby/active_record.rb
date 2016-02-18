module Wallaby::ActiveRecord
  def self.model_decorator
    Wallaby::ActiveRecord::ModelDecorator
  end

  def self.model_finder
    Wallaby::ActiveRecord::ModelFinder
  end

  def self.model_servicer
    Wallaby::ActiveRecord::ModelServicer
  end
end
