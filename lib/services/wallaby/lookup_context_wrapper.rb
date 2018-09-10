module Wallaby
  # @!visibility private
  # Lookup context wrapper.
  #
  # This is to take care of missing template in production.
  # It will return `string` template
  # if it doesn't know how to handle the template.
  # @see Wallaby::PartialRenderer
  class LookupContextWrapper
    origin_methods = ::ActionView::LookupContext.instance_methods \
      - ::Object.instance_methods - %i(find_template)
    delegate(*origin_methods, to: :@lookup_context)

    # @param lookup_context [ActionView::LookupContext]
    def initialize(lookup_context)
      @lookup_context = lookup_context
    end

    # @see ActionView::LookupContext#find_template
    # @param args [Array] a list of arguments
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

      # @param args [Array] a list of arguments
      # @return [nil]
      def render(*args); end

      # @param args [Array] a list of arguments
      # @return [nil]
      def virtual_path(*args); end
    end
  end
end
