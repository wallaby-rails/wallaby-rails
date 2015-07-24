module Wallaby
  module Services
    def self.class_finder
      ClassFinder
    end

    def self.model_decorator
      ModelDecorator
    end

    def self.record_decorator
      RecordDecorator
    end
  end
end