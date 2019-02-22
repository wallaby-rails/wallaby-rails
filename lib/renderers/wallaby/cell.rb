module Wallaby
  # In order to improve the rendering performance, cell is used as simple partial component.
  # @since 5.2.0
  class Cell
    # @!attribute [r] context
    # @return [Object] view context
    attr_reader :context

    # @!attribute [r] local_assigns
    # @return [Hash] a list of local_assigns containing {#object}, {#field_name}, {#value}, {#metadata} and {#form}
    attr_reader :local_assigns

    # @!attribute form
    # @return [ActionView::Helpers::FormBuilder] form object
    attr_accessor :form

    # @!attribute object
    # @return [Wallaby::ResourceDecorator] resource decorator
    attr_accessor :object

    # @!attribute field_name
    # @return [String] field name
    attr_accessor :field_name

    # @!attribute value
    # @return [String] value
    attr_accessor :value

    # @!attribute metadata
    # @return [String] metadata
    attr_accessor :metadata

    # @!attribute [r] buffer
    # @return [String] output string buffer
    attr_reader :buffer

    delegate(*ERB::Util.singleton_methods, to: ERB::Util)

    # @param context [Object] view context
    # @param local_assigns [Hash] local variables
    def initialize(context, local_assigns)
      @context = context
      @local_assigns = local_assigns
      @form = @local_assigns[:form]
      @object = @local_assigns[:object]
      @field_name = @local_assigns[:field_name]
      @value = @local_assigns[:value]
      @metadata = @local_assigns[:metadata]
    end

    # @note this is a template method that can be overridden by subclasses
    # Produce output for this cell component.
    #
    # Please note that the output doesn't include the buffer produced by {#concat}.
    # Therefore, use {#render_complete} method instead when the cell is rendered.
    def render(*); end

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

    private

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
