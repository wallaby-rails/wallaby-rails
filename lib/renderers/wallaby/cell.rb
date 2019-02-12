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

    # @!attribute object
    # @return [Object] resource object
    attr_accessor :object

    # @!attribute field_name
    # @return [String, Symbol] field name
    attr_accessor :field_name

    # @!attribute value
    # @return [Object] value for a specific field name
    attr_accessor :value

    # @!attribute metadata
    # @return [Hash] metadata
    attr_accessor :metadata

    # @!attribute form
    # @return [ActionView::Helpers::FormBuilder] form object
    attr_accessor :form

    delegate(*ERB::Util.singleton_methods, to: ERB::Util)

    # @param context [Object] view context
    # @param locals [Hash] locals for the cell
    def initialize(context, locals)
      @context = context
      @locals = locals
      %i(object field_name value metadata form).each do |var|
        instance_variable_set :"@#{var}", @locals[var]
      end
    end

    # @return [String] output of the cell
    def render_complete(&block)
      @buffer = EMPTY_STRING.html_safe
      last_part = render(&block)
      last_part = last_part.to_s unless last_part.is_a? String
      @buffer << last_part
    end

    # Append string to output buffer
    # @param string [String] string to concat
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
