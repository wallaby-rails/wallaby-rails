module Wallaby
  # Preload utils
  module PreloadUtils
    class << self
      # Preload all files under app folder
      def require_all
        eager_load_paths.map(&method(:require_one))
      end

      # Require files under a load path
      # @params load_path [String, Pathname]
      # @see {https://api.rubyonrails.org/classes/Rails/Engine.html#method-i-eager_load-21 Rails::Engine#eager_load!}
      def require_one(load_path)
        Dir.glob("#{load_path}/**/*.rb").sort.each(&method(:load_class_for))
      end

      protected

      # @return [Array<String, Pathname>] a list of special sorted eager load paths
      def eager_load_paths
        Rails.configuration.eager_load_paths.sort_by do |path|
          - path.index(%r{/models$}).to_i
        end
      end

      # `constantize` is used to make Rails to handle all sort of load errors
      # NOTE: don't try to use `ActiveSupport::Dependencies::Loadable.require_dependency`
      # as `require_dependency` does not take care all errors when class/module is declared
      # @param file_path [Pathname, String]
      def load_class_for(file_path)
        module_name = file_path[%r{app/[^/]+/(.+)\.rb}, 1].gsub('/concerns/', '/')
        class_name = module_name.camelize
        class_name.constantize unless Module.const_defined? class_name
      rescue NameError, LoadError => e
        Rails.logger.debug "  [WALLABY] Preload warning: #{e.message} from #{file_path}"
        Rails.logger.debug e.backtrace.slice(0, 5)
      end
    end
  end
end
