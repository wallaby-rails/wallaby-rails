module Wallaby
  class Configuration
    attr_accessor :models
    attr_accessor :data_access_mode

    def initialize
      @models = Models.new
    end

    def model_finder
      @model_finder ||= Wallaby::ActiveRecordModelFinder
    end

    def model_decorator
      @model_decorator ||= Wallaby::ActiveRecordModelDecorator
    end
  end

  def self.configuration
    @configuration ||= Configuration.new
  end
end

require 'wallaby/configuration/models'