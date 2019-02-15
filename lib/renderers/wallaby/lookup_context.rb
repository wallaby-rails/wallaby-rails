module Wallaby
  # A custom lookup context that uses {Wallaby::CellResolver}.
  class LookupContext < ::ActionView::LookupContext
    # It overrides the origin method to wrap paths using {Wallaby::CellResolver}
    # @param paths [Array]
    def view_paths=(paths)
      @view_paths = ActionView::PathSet.new Array(paths).map(&method(:convert))
    end

    # It overrides the oirgin method to call the origin `find_template` and cache the result during a request.
    # @param args [Array]
    def find_template(*args)
      key = args.map(&:inspect).join('/')
      cached_search[key] ||= super
    end

    # @!attribute [r] cached_search
    # Cached cell and partial lookup result.
    def cached_search
      @cached_search ||= {}
    end

    private

    # Wrap path using {Wallaby::CellResolver}
    # @param path [Object]
    def convert(path)
      case path
      when ActionView::OptimizedFileSystemResolver, Pathname, String
        CellResolver.new path.to_s
      else
        path
      end
    end
  end
end
