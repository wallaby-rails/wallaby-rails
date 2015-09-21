module Wallaby::ActiveRecord
  def self.model_decorator
    self::ModelDecorator
  end

  def self.model_finder
    self::ModelFinder
  end
end
