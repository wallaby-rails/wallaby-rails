module Wallaby
  # Lookup context wrapper
  class LookupContextWrapper
    origin_methods = ActionView::LookupContext.instance_methods \
        - Object.instance_methods - %i[find_template]
    delegate(*origin_methods, to: :@lookup_context)

    def initialize(lookup_context)
      @lookup_context = lookup_context
    end

    def find_template(*args)
      key = args.join '/'
      caching key do
        @lookup_context.find_template(*args)
      end
    end

    protected

    def caching(key)
      @templates ||= {}
      unless @templates.key? key
        @templates[key] = begin
          yield
        rescue ActionView::MissingTemplate
          raise if Rails.env.development?
          BlankTemplate.new
        end
      end
      @templates[key]
    end

    # Blank template
    class BlankTemplate < ActionView::Template::HTML
      def initialize
        super nil
      end

      def render(*args); end
    end
  end
end
