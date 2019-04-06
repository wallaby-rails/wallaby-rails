module Wallaby
  # In order to improve the rendering performance, cell is designed as simple partial component.
  # @since 5.2.0
  class Cell
    # @!attribute [r] context
    # @return [Object] view context
    attr_reader :context

    # @!attribute [r] local_assigns
    # @return [Hash] a list of local_assigns containing {#object}, {#field_name}, {#value}, {#metadata} and {#form}
    attr_reader :local_assigns

    # @!attribute [r] buffer
    # @return [String] output string buffer
    attr_reader :buffer

    delegate(*ERB::Util.singleton_methods, to: ERB::Util)

    # @param context [ActionView::Context] view context
    # @param local_assigns [Hash] local variables
    def initialize(context, local_assigns)
      @context = context
      @local_assigns = local_assigns
    end

    # @!attribute [r] object
    # @return [Object] object
    def object
      local_assigns[:object]
    end

    # @!attribute [w] object
    def object=(object)
      local_assigns[:object] = object
    end

    # @!attribute [r] field_name
    # @return [String] field name
    def field_name
      local_assigns[:field_name]
    end

    # @!attribute [w] field_name
    def field_name=(field_name)
      local_assigns[:field_name] = field_name
    end

    # @!attribute [r] value
    # @return [String] value
    def value
      local_assigns[:value]
    end

    # @!attribute [w] value
    def value=(value)
      local_assigns[:value] = value
    end

    # @!attribute [r] metadata
    # @return [String] metadata
    def metadata
      local_assigns[:metadata]
    end

    # @!attribute [w] metadata
    def metadata=(metadata)
      local_assigns[:metadata] = metadata
    end

    # @!attribute [r] form
    # @return [ActionView::Helpers::FormBuilder] form object
    def form
      local_assigns[:form]
    end

    # @!attribute [w] form
    def form=(form)
      local_assigns[:form] = form
    end

    # @note this is a template method that can be overridden by subclasses
    # Produce output for this cell component.
    #
    # Please note that the output doesn't include the buffer produced by {#concat}.
    # Therefore, use {#render_complete} method instead when the cell is rendered.
    def render; end

    # This method produces the complete rendered string including the buffer produced by {#concat}.
    # @return [String] output of the cell
    def render_complete(&block)
      @buffer = EMPTY_STRING.html_safe # reset buffer before rendering
      last_part = render(&block)
      @buffer << last_part.to_s
    end

    # Append string to output buffer
    # @param string [String] string to concat
    def concat(string)
      (@buffer ||= EMPTY_STRING.html_safe) << string
    end

    # @overload at(name)
    #   Get view instance variable value
    #   @example To get view instance variable value
    #     at('name') # => get value of `@name` from the view
    #   @param name [String, Symbol] view instance variable name without `@`
    # @overload at(name, value)
    #   Set view instance variable value
    #   @example To set view instance variable value
    #     at('name', value) # => set value of `@name` in the view
    #   @param name [String, Symbol] view instance variable name without `@`
    #   @param value [object] value
    # @return [object] view instance variable value
    def at(*args)
      raise ArgumentError unless args.length.in? [1, 2]
      return context.instance_variable_get :"@#{args.first}" if args.length == 1
      context.instance_variable_set :"@#{args.first}", args.last
    end

    private

    # Delegate missing method to {#context}
    def method_missing(method_id, *args, &block)
      return super unless context.respond_to? method_id
      context.public_send method_id, *args, &block
    end

    # Delegate missing method check to {#context}
    def respond_to_missing?(method_id, _include_private)
      context.respond_to?(method_id) || super
    end
  end
end
