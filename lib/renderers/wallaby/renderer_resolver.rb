module Wallaby
  # Look up renderers and all view files
  class RendererResolver < ActionView::OptimizedFileSystemResolver
    # DEFAULT_PATTERN = ":prefix/:action{{_:locale,}{_:format,}.rb,{.:locale,}{.:formats,}{+:variants,}{.:handlers,}}"

    # def initialize(path, pattern = nil)
    #   pattern ||= DEFAULT_PATTERN
    #   super
    # end

    # @param path [String]
    # @param details [Details]
    # @return [String]
    def build_query(path, details)
      origin = super
      file_name = origin[%r{(?<=/_)[^/\{]+}]
      return origin unless file_name
      base_dir = origin.gsub(%r{/[^/]*$}, '')
      locales = convert details[:locale]
      formats = convert details[:formats]
      renderer = "#{base_dir}/#{file_name}{#{locales}}{#{formats}}.rb"
      "{#{renderer},#{origin}}"
    end

    def convert(values)
      (values.map { |v| "_#{v}" } << '').join ','
    end
  end
end
