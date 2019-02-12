module Wallaby
  # In order to improve the rendering performance, cell is used as simple partials.
  # @since 5.2.0
  class Cell
    # @!attribute [r] context
    # @return [ActionView::Context] view context
    attr_reader :context

    # @!attribute [r] locals
    # @return [Hash] a list of locals for urrent object
    attr_reader :locals

    # @!attribute [r] locals
    # @return [Hash] a list of locals for urrent object
    attr_accessor :object, :field_name, :value, :metadata, :form

    delegate(*ERB::Util.singleton_methods, to: ERB::Util)

    # @param context []
    def initialize(context, locals)
      @context = context
      @locals = locals
      %i(object field_name value metadata form).each do |var|
        instance_variable_set :"@#{var}", @locals[var]
      end
    end

    def render_complete(&block)
      @buffer = EMPTY_STRING.html_safe
      last_part = render(&block)
      last_part = last_part.to_s unless last_part.is_a? String
      @buffer << last_part
    end

    def concat(string)
      (@buffer ||= EMPTY_STRING.html_safe) << string
    end

    # We delegate missing methods to context
    # @param method_id [String,Symbol]
    # @param args [Array]
    def method_missing(method_id, *args)
      return super unless @context.respond_to? method_id
      @context.public_send method_id, *args
    end

    # @param method_id [String,Symbol]
    # @param _include_private [Boolean]
    def respond_to_missing?(method_id, _include_private)
      @context.respond_to?(method_id) || super
    end
  end
end
