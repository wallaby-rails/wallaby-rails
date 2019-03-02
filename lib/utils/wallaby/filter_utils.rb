module Wallaby
  # Filter utils
  module FilterUtils
    # Find filter name in the following precedences from high to low:
    #
    # - `filter_name` argument
    # - filters that has been marked as default
    # - `:all`
    # @param filter_name [String, Symbol] filter name
    # @param filters [Hash] filter metadata
    # @return [String, Symbol]
    def self.filter_name_by(filter_name, filters)
      filter = filter_name # from param
      filter ||= filters.find { |_k, v| v[:default] }.try(:first) # from default value
      filter || :all # last resort
    end
  end
end
