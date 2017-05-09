# Wallaby
module Wallaby
  # Global configuration
  class Configuration
    attr_writer :base_controller

    def models
      @models ||= Models.new
    end

    def models=(models)
      self.models.set models
    end

    def security
      @security ||= Security.new
    end

    def base_controller
      @base_controller ||= ::ApplicationController
    end

    def clear
      @models = nil
      @security = nil
      @base_controller = nil
    end
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.config
    yield configuration
  end
end

require 'wallaby/configuration/models'
require 'wallaby/configuration/security'
