module Wallaby
  # @!visibility private
  # Prefix builder
  class PrefixesBuilder
    # @param origin_prefixes [Array<string>] a list of all the prefixes
    # @param controller_path [String] controller path
    # @param resources_name [String] resources name
    # @param params [ActionController::Parameters]
    def initialize(origin_prefixes, controller_path, resources_name, params)
      @origin_prefixes = origin_prefixes
      @controller_path = controller_path
      @resources_name = resources_name
      @params = params
    end

    # @return [Array<String>] a list of all the prefixes
    def build
      prefixes = minimal_prefixes
      prefixes.unshift mounted_prefix if resource_path != @controller_path
      suffix = build_suffix(@params)
      prefixes.each_with_object([]) do |prefix, result|
        result << "#{prefix}/#{suffix}" << prefix if prefix
      end
    end

    protected

    # @return [Array<String>] a list of prefixes starting from wallaby
    def minimal_prefixes
      # this should contains only the current controller's path and wallaby path
      index = @origin_prefixes.index wallaby_path
      @origin_prefixes.slice 0..index
    end

    # @return [String] a prefix of the mouted path.
    #   Given mounted path `admin`, and current resources `products`, it returns
    #   `admin/products`
    def mounted_prefix
      prefix = mounted_path.try(:slice, 1..-1) || ''
      prefix << SLASH unless prefix.empty?
      prefix << resource_path if resource_path
    end

    # Consolidate action name (new/create/edit/update) as `form`
    # @param params [ActionController::Parameters]
    # @return [String]
    def build_suffix(params)
      Utils.to_partial_name params[:action]
    end

    # @return [String] path of `wallaby/resources`
    def wallaby_path
      ResourcesController.controller_path
    end

    # @return [String] the path that Wallaby has mounted to
    def mounted_path
      # TODO: need to find out if this will fail
      # when wallaby is mounted more than once on different namespace?
      Rails.application.routes.named_routes[:wallaby_engine].try do |route|
        route.path.spec.to_s
      end
    end

    # Convert the resources name
    # (e.g. `namespace::products` to `namespace/products`)
    # @return [String] a path of the resources
    def resource_path
      @resource_path ||= @resources_name.try :gsub, COLONS, SLASH
    end
  end
end
