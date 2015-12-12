module Wallaby
  class Configuration
    def adaptor
      @adaptor ||= Wallaby::ActiveRecord
    end

    def adaptor=(adaptor)
      if @adaptor
        fail 'Adaptor has been initialized. Please place adaptor assignment at the top of configuration.'
      end
      @adaptor = adaptor
    end

    def models
      @models ||= Models.new
    end

    def security
      @security ||= Security.new
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