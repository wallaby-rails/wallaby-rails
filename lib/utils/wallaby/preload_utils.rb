module Wallaby
  # Preload utils
  module PreloadUtils
    class << self
      # Preload all files under app folder
      def require_all
        eager_load_paths.map(&method(:require_one))
      end

      # Require files under a load path
      def require_one(load_path)
        load_path = eager_load_path_of load_path unless load_path.start_with? '/'
        matcher = /\A#{Regexp.escape(load_path.to_s)}\/(.*)\.rb\Z/
        Dir.glob("#{load_path}/**/*.rb").sort.each do |file|
          require_one_dependency file, matcher
        end
      end

      protected

      def require_one_dependency(file, matcher)
        path = file.sub(matcher, '\1')
        require_dependency path
      rescue NameError => e
        Rails.logger.error "Error loading: #{e.message} at #{e.backtrace[0]}"
      end

      def eager_load_paths
        Rails.configuration.eager_load_paths.sort_by do |path|
          - path.index(%r{/models$}).to_i
        end
      end

      def eager_load_path_of(path)
        eager_load_paths.find do |eager|
          eager.index path
        end
      end
    end
  end
end
