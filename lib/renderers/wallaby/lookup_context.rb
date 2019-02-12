module Wallaby
  # A custom lookup context
  class LookupContext < ::ActionView::LookupContext
    # Set paths
    # @param paths [Array]
    def view_paths=(paths)
      @view_paths = ActionView::PathSet.new Array(paths).map(&method(:convert))
    end

    # @param args
    def find_template(*args)
      key = args.map(&:inspect).join('/')
      cached_search[key] ||= super
    end

    private

    # @!attribute [r] cached_search
    # to cache partial lookup result
    def cached_search
      @cached_search ||= {}
    end

    def convert(path)
      case path
      when ActionView::OptimizedFileSystemResolver, Pathname, String
        RendererResolver.new path.to_s
      else
        path
      end
    end
  end
end
