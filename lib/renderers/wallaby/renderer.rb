module Wallaby
  # In order to improve the rendering performance, renderer is used to render simple partials.
  class Renderer
    attr_reader :context, :locals
    attr_accessor :object, :field_name, :value, :metadata, :form

    # @param context []
    def initialize(context, locals)
      @context = context
      @locals = locals
      %i[object field_name value metadata form].each do |var|
        instance_variable_set :"@#{var}", @locals[var]
      end
    end

    def render_complete(&block)
      @buffer = ''.html_safe
      last_part = render &block
      last_part = last_part.to_s unless last_part.is_a? String
      @buffer << last_part
    end

    def concat(string)
      @buffer << string
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
