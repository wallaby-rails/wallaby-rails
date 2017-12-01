# Wallaby
module Wallaby
  # Global configuration
  class Configuration
    attr_writer :base_controller, :page_size

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

    def page_size
      @page_size ||= DEFAULT_PAGE_SIZE
    end

    def metadata
      @metadata ||= Metadata.new
    end

    def clear
      @models = nil
      @security = nil
      @base_controller = nil
      @page_size = nil
      @metadata = nil
    end
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.config
    yield configuration
  end
end
