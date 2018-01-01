module Wallaby
  # Lookup context wrapper.
  # This is to take care of missing template in production to return string
  # template.
  # @see Wallaby::PartialRenderer
  class LookupContextWrapper
    origin_methods = ::ActionView::LookupContext.instance_methods \
      - ::Object.instance_methods - %i(find_template)
    delegate(*origin_methods, to: :@lookup_context)

    def initialize(lookup_context)
      @lookup_context = lookup_context
    end

    def find_template(*args)
      @lookup_context.find_template(*args)
    rescue ::ActionView::MissingTemplate
      raise if Rails.env.development?
      BlankTemplate.new
    end

    # Blank template to return nil. It should be used by production
    class BlankTemplate < ::ActionView::Template::HTML
      def initialize
        super nil
      end

      def render(*args); end

      def virtual_path(*args); end
    end
  end
end
