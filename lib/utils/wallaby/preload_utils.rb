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
        matcher = /\A#{Regexp.escape(load_path.to_s)}\/(.*)\.rb\Z/
        Dir.glob("#{load_path}/**/*.rb").sort.each do |file|
          require_dependency file.sub(matcher, '\1')
        end
      end

      protected

      # @return [Array<String, Pathname>] a list of special sorted eager load paths
      def eager_load_paths
        Rails.configuration.eager_load_paths.sort_by do |path|
          - path.index(%r{/models$}).to_i
        end
      end
    end
  end
end
