module ActionDispatch
  module Routing
    # Re-open ActionDispatch::Routing::Mapper to add support for Wallaby
    class Mapper
      # @params resource_names [Array<String, Symbol>]
      # @example To generate resourcesful routes that works for Wallaby:
      #   wresources :postcodes
      #   # => same effect as
      #   resources(
      #     :postcodes,
      #     path: ':resources',
      #     defaults: { resources: :postcodes },
      #     constraints: { resources: :postcodes }
      #   )
      # @see https://api.rubyonrails.org/classes/ActionDispatch/Routing/Mapper/Resources.html#method-i-resources
      #   ActionDispatch::Routing::Mapper::Resources#resources
      def wresources(*resource_names, &block)
        options = resource_names.extract_options!.dup
        resource_names.each do |resource_name|
          each_options = default_wallaby_options_for resource_name, options
          resources resource_name, each_options, &block
        end
      end

      # @params resource_names [Array<String, Symbol>]
      # @example To generate resourceful routes that works for Wallaby:
      #   wresource :profile
      #   # => same effect as
      #   resource(
      #     :profile,
      #     path: ':resource',
      #     defaults: { resource: :profile },
      #     constraints: { resource: :profile }
      #   )
      # @see https://api.rubyonrails.org/classes/ActionDispatch/Routing/Mapper/Resources.html#method-i-resource
      #   ActionDispatch::Routing::Mapper::Resources#resource
      def wresource(*resource_names, &block)
        options = resource_names.extract_options!.dup
        resource_names.each do |resource_name|
          each_options = default_wallaby_options_for resource_name, options
          resources resource_name, each_options, &block
        end
      end

      protected

      # Fill in the options required by Wallaby
      # @param resource_name [String, Symbol]
      # @param options [Hash]
      def default_wallaby_options_for(resource_name, options)
        { path: ':resources' }.merge!(options).tap do |new_options|
          %i(defaults constraints).each do |key|
            new_options[key] = { resources: resource_name }.merge!(new_options[key] || {})
          end
        end
      end
    end
  end
end
