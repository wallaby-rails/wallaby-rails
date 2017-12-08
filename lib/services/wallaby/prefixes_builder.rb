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
      prefixes.each_with_object([]) do |prefix, result|
        result << "#{prefix}/#{suffix}" << prefix if prefix
      end
    end

    protected

    def minimal_prefixes
      # this should contains only the current controller's path and wallaby path
      index = @origin_prefixes.index wallaby_path
      @origin_prefixes.slice 0..index
    end

    def mounted_prefix
      prefix = mounted_path.try(:slice, 1..-1) || ''
      prefix << SLASH unless prefix.empty?
      prefix << resource_path if resource_path
    end

    def build_suffix(params)
      form_actions = %w(new create edit update)
      form_actions.include?(params[:action]) ? 'form' : params[:action]
    end

    def wallaby_path
      ResourcesController.controller_path
    end

    def mounted_path
      # TODO: need to find out if  this will fail
      # when wallaby is mounted more than once on different namespace?
      Rails.application.routes.named_routes[:wallaby_engine].try do |route|
        route.path.spec.to_s
      end
    end

    def resource_path
      @resource_path ||= @resources_name.try :gsub, COLONS, SLASH
    end
  end
end
