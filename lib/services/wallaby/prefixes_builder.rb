module Wallaby
  # Prefix builder
  class PrefixesBuilder
    def initialize(origin_prefixes, controller_path, resources_name, params)
      @origin_prefixes = origin_prefixes
      @controller_path = controller_path
      @resources_name = resources_name
      @params = params
    end

    def build
      prefixes = minimal_prefixes
      prefixes.unshift mounted_prefix if resource_path != @controller_path
      suffix = build_suffix(@params)
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
      prefix = mounted_path.slice(1..-1) || EMPTY_STRING
      prefix << SLASH unless prefix.empty?
      prefix << resource_path
    end

    def build_suffix(params)
      form_actions = %w[new create edit update]
      form_actions.include?(params[:action]) ? 'form' : params[:action]
    end

    def wallaby_path
      Wallaby::ResourcesController.controller_path
    end

    def mounted_path
      Rails.application.routes.named_routes[:wallaby_engine].path.spec.to_s
    end

    def resource_path
      @resource_path ||= @resources_name.gsub COLONS, SLASH
    end
  end
end
