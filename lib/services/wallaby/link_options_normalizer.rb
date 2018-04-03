module Wallaby
  # @private
  # Link renderer
  class LinkOptionsNormalizer
    # Normalize options for `link_to` to use
    # @param html_options [Hash] html options
    # @param block [Proc] a block
    # @param defaults [Hash]
    # @return [Array<Hash, Proc>] html_options and the block
    def self.normalize(html_options, block, defaults)
      block ||= defaults[:block]
      html_options[:title] ||= defaults[:block].call
      # allow empty class to be set
      if !html_options.key?(:class) && defaults[:class]
        html_options[:class] = defaults[:class]
      end
      [html_options, block]
    end
  end
end
