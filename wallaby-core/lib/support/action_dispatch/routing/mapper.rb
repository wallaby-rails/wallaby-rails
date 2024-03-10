# frozen_string_literal: true

module ActionDispatch
  module Routing
    # Re-open {https://api.rubyonrails.org/classes/ActionDispatch/Routing/Mapper.html
    # ActionDispatch::Routing::Mapper}
    # to add route helpers for {Wallaby}.
    class Mapper
      # Mount {Wallaby::Engine} at given path.
      # And prepend custom routes to Rails app if block is given.
      # @example Mount {Wallaby::Engine} at a path
      #   wallaby_mount at: '/admin'
      # @example Mount {Wallaby::Engine} and prepend custom routes
      #   wallaby_mount at: '/super_admin' do
      #     resource :accounts
      #   end
      #   # the above code is the same as:
      #   namespace :super_admin do
      #     resource :accounts
      #   end
      #   mount Wallaby::Engine, at: '/super_admin'
      # @param options [Hash]
      # @option options [String] :at the path which {Wallaby::Engine} is mounted at
      # @option options [Symbol, String] :as {Wallaby::Engine} alias name for URL helpers
      # @option options [Array] :via HTTP methods that {Wallaby::Engine} processes
      def wallaby_mount(options, &block)
        # define routes under namespace (e.g. `:admin`) before mounting the {Wallaby:Engine} (e.g. at `/admin`)
        namespace(options[:at][1..] || '', options.except(:at), &block) if block
        mount Wallaby::Engine, options.slice(:at, :as, :via)
      end

      # Generate **resourceful** routes that works for Wallaby.
      # @example To generate resourceful routes that works for Wallaby:
      #   wresources :postcodes
      #   # => same effect as
      #   resources(
      #     :postcodes,
      #     path: ':resources',
      #     defaults: { resources: :postcodes },
      #     constraints: { resources: :postcodes }
      #   )
      # @param resource_names [Array<String, Symbol>]
      # @see https://api.rubyonrails.org/classes/ActionDispatch/Routing/Mapper/Resources.html#method-i-resources
      #   ActionDispatch::Routing::Mapper::Resources#resources
      def wresources(*resource_names, &block)
        options = Wallaby::Utils.clone resource_names.extract_options!
        resource_names.each do |resource_name|
          new_options = wallaby_resources_options_for resource_name, options
          resources resource_name, new_options, &block
        end
      end

      # Generate **resourceful** routes that works for Wallaby.
      # @example To generate resourceful routes that works for Wallaby:
      #   wresource :profile
      #   # => same effect as
      #   resource(
      #     :profile,
      #     path: ':resource',
      #     defaults: { resource: :profile, resources: :profiles },
      #     constraints: { resource: :profile, resources: :profiles }
      #   )
      # @param resource_names [Array<String, Symbol>]
      # @see https://api.rubyonrails.org/classes/ActionDispatch/Routing/Mapper/Resources.html#method-i-resource
      #   ActionDispatch::Routing::Mapper::Resources#resource
      def wresource(*resource_names, &block)
        options = Wallaby::Utils.clone resource_names.extract_options!
        resource_names.each do |resource_name|
          new_options = wallaby_resource_options_for resource_name, options
          resource resource_name, new_options, &block
        end
      end

      protected

      # Fill in the **resources** options required by Wallaby
      # @param resources_name [String, Symbol]
      # @param options [Hash]
      def wallaby_resources_options_for(resources_name, options)
        { path: ':resources' }.merge!(options).tap do |new_options|
          %i[defaults constraints].each do |key|
            new_options[key] = { resources: resources_name }.merge!(new_options[key] || {})
          end
        end
      end

      # Fill in the **resource** options required by Wallaby
      # @param resource_name [String, Symbol]
      # @param options [Hash]
      def wallaby_resource_options_for(resource_name, options)
        plural_resources = Wallaby::Inflector.to_resources_name resource_name
        { path: ':resource' }.merge!(options).tap do |new_options|
          %i[defaults constraints].each do |key|
            new_options[key] = { resource: resource_name, resources: plural_resources }.merge!(new_options[key] || {})
          end
        end
      end
    end
  end
end
