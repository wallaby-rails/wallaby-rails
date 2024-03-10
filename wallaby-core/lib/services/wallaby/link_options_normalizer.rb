# frozen_string_literal: true

module Wallaby
  # Link renderer
  class LinkOptionsNormalizer
    # Normalize options for `link_to` to use
    # @param html_options [Hash] HTML options
    # @param block [Proc] a block
    # @param defaults [Hash]
    # @return [Array<Hash, Proc>] html_options and the block
    def self.normalize(html_options, block, defaults)
      html_options = Utils.clone html_options
      block ||= defaults[:block]
      html_options[:title] ||= defaults[:block].call
      # allow empty class to be set
      html_options[:class] = defaults[:class] if !html_options.key?(:class) && defaults[:class]
      [html_options, block]
    end
  end
end
