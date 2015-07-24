module Wallaby
  class Configuration
    attr_accessor :models
    attr_accessor :data_access_mode

    def initialize
      @models = Models.new
    end
  end

  def self.configuration
    @configuration ||= Configuration.new
  end
end

require 'wallaby/configuration/models'