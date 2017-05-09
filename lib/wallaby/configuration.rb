# Wallaby
module Wallaby
  # Global configuration
  class Configuration
    attr_writer :base_controller

    def adaptor
      @adaptor ||= Wallaby::ActiveRecord
    end

    def adaptor=(adaptor)
      if @adaptor
        raise <<-ERROR
          [Wallaby] Adaptor has been initialized.
          Please place adaptor assignment at the top of configuration.
        ERROR
      end
      @adaptor = adaptor
    end

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

  def self.adaptor
    configuration.adaptor
  end
end

require 'wallaby/configuration/models'
require 'wallaby/configuration/security'
