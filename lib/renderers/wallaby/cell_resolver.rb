module Wallaby
  # Cell and partial resolver
  # @see https://github.com/reinteractive/wallaby/blob/master/docs/view.md
  class CellResolver < ActionView::OptimizedFileSystemResolver
    # In addition to the origin query, Wallaby adds cell query which looks like before the origin query:
    #
    # ```
    # app/views/wallaby/resources/index/integer{_en,}{_html,}.rb
    # ```
    # @param path [String]
    # @param details [Hash]
    #   see {https://api.rubyonrails.org/classes/ActionView/LookupContext/ViewPaths.html#method-i-detail_args_for
    #   Detials from ViewPaths}
    # @return [String] a string of the path query
    def build_query(path, details)
      origin = super
      file_name = origin[%r{(?<=/_)[^/\{]+}]
      return origin unless file_name
      base_dir = origin.gsub(%r{/[^/]*$}, '')
      locales = convert details[:locale]
      formats = convert details[:formats]
      cell = "#{base_dir}/#{file_name}{#{locales}}{#{formats}}.rb"
      "{#{cell},#{origin}}"
    end

    protected

    # @example concat a list of values into a string e.g. `_html,_cvs,`
    #   convert(['html', 'csv']) # => '_html,_cvs,'
    # @param values [Array<String>]
    def convert(values)
      (values.map { |v| "_#{v}" } << '').join ','
    end
  end
end
