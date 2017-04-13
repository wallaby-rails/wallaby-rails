module Wallaby
  class PrefixesBuilder
    def initialize(origin_prefixes, controller_path, resources_name, params)
      @origin_prefixes = origin_prefixes
      @controller_path = controller_path
      @resources_name = resources_name
      @params = params
    end

    def build
      prefixes = minimal_prefixes
      if resource_path != @controller_path
        prefixes.unshift mounted_prefix
      end
      prefixes.inject([]) do |result, prefix|
        result << "#{prefix}/#{suffix}" << prefix
      end
    end

    protected

    def minimal_prefixes
      # this should contains only the current controller's path and wallaby path
      index = @origin_prefixes.index wallaby_path
      @origin_prefixes.slice 0..index
    end

    def mounted_prefix
      prefix = mounted_path.slice(1..-1) || ''
      prefix << '/' unless prefix.empty?
      prefix << resource_path
    end

    def wallaby_path
      Wallaby::ResourcesController.controller_path
    end

    def mounted_path
      Rails.application.routes.named_routes[:wallaby_engine].path.spec.to_s
    end

    def resource_path
      @resource_path ||= @resources_name.tr '::', '/'
    end
  end
end
