module Wallaby
  class LookupContext < ::ActionView::LookupContext
    def view_paths=(paths)
      @view_paths = ActionView::PathSet.new Array(paths).map(&method(:convert))
    end

    private

    def convert(path)
      case path
      when ActionView::OptimizedFileSystemResolver, ActionView::Pathname, String
        RendererResolver.new path.to_s
      else
        path
      end
    end
  end
end
