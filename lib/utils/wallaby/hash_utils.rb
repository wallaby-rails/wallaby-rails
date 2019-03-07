module Wallaby
  # Hash utils
  module HashUtils
    # Create hash with indifference and default
    # @param hash [Hash]
    # @return [ActiveSupport::HashWithIndifferentAccess]
    def self.default(hash = {}, &block)
      ActiveSupport::HashWithIndifferentAccess.new(&block).merge(hash)
    end
  end
end
