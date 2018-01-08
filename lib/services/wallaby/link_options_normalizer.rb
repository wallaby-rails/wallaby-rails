module Wallaby
  # Link renderer
  class LinkOptionsNormalizer
    class << self
      def normalize(html_options, block, defaults)
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
end
