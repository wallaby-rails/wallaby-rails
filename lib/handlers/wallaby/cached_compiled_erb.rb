require 'erubis'

# TODO: more performance investigation for this
module Wallaby
  # Cache compiled ERB file
  class CachedCompiledErb < ActionView::Template::Handlers::ERB
    def call(template)
      if Rails.env.development?
        super
      else
        Rails.cache.fetch "wallaby/views/erb/#{template.inspect}" do
          super
        end
      end
    end
  end
end
