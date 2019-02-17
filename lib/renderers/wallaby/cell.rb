module Wallaby
  # In order to improve the rendering performance, cell is used as simple partial component.
  # @since 5.2.0
  class Cell
    # @!attribute [r] context
    # @return [Object] view context
    attr_reader :context

    # @!attribute [r] locals
    # @return [Hash] a list of locals including {#object}, {#field_name}, {#value}, {#metadata} and {#form}
    attr_reader :locals

    # @!attribute [r] form
    # @return [ActionView::Helpers::FormBuilder] form object
    attr_reader :form

    # @!attribute [r] buffer
    # @return [String] string buffer
    attr_reader :buffer

    delegate(*ERB::Util.singleton_methods, to: ERB::Util)

    # @param context [Object] view context
    # @param locals [Hash] locals for the cell
    def initialize(context, locals)
      @context = context
      @locals = locals
      @form = @locals.delete :form
    end

    # @note this is a template method that can be overridden by subclasses
    # Produce output for this cell component.
    #
    # Please note that the output doesn't include the buffer produced by {#concat}.
    # Therefore, use {#render_complete} method instead when the cell is rendered.
    def render(*args); end

    # This method produces the complete rendered string including the buffer produced by {#concat}.
    # @return [String] output of the cell
    def render_complete(&block)
      @buffer = EMPTY_STRING.html_safe
      last_part = render(**locals, &block)
      last_part = last_part.to_s unless last_part.is_a? String
      @buffer << last_part
    end

    # Append string to output buffer
    # @param string [String] string to concat
    def concat(string)
      (@buffer ||= EMPTY_STRING.html_safe) << string
    end

    protected

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
