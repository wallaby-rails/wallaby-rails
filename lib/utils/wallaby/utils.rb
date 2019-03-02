module Wallaby
  # Utils
  module Utils
    # Display deprecate message including the line where it's used
    # @param key [String]
    # @param caller [String] the line where it's called
    # @param options [Hash]
    def self.deprecate(key, caller:, options: {})
      warn I18n.t(key, options.merge(from: caller[0]))
    end

    # @deprecated Use {Wallaby::FilterUtils.filter_name_by} instead. It will be removed from 5.3.*
    def self.find_filter_name(filter_name, filters)
      deprecate 'deprecation.find_filter_name', caller: caller
      FilterUtils.filter_name_by filter_name, filters
    end

    # @see http://stackoverflow.com/a/8710663/1326499
    # @param object [Object]
    # @return [Object] a clone object
    def self.clone(object)
      ::Marshal.load(::Marshal.dump(object))
    end
  end
end
