module Wallaby
  # Resources helper
  module ResourcesHelper
    include BaseHelper
    include FormHelper
    include IndexHelper

    include Authorizable
    include Decoratable
    include Paginatable
    include Resourcable
    include Servicable
    include Themeable

    # @deprecated Use {#type_render} instead. It will be removed from 5.3.*
    def type_partial_render(options = {}, locals = {}, &block)
      Utils.deprecate 'deprecation.type_partial_render', caller: caller
      type_render options, locals, &block
    end

    # Render type cell/partial
    # @param partial_name [String]
    # @param locals [Hash]
    def type_render(partial_name = '', locals = {}, &block)
      TypeRenderer.render self, partial_name, locals, &block
    end

    # Title for show page of given resource
    # @param decorated [Wallaby::ResourceDecorator]
    # @return [String]
    def show_title(decorated)
      raise ::ArgumentError unless decorated.is_a? ResourceDecorator
      [
        to_model_label(decorated.model_class), decorated.to_label
      ].compact.join ': '
    end

    # To find the first field that meets given conditions.
    # @example To find summary field whose name contains _summary_ and type is **string**:
    #   first_field_by({ name: /summary/, type: 'string' })
    # @param conditions [Array<Hash>]
    # @return [String, Symbol] field name when found
    # @return [nil] when not found
    def first_field_by(*conditions)
      fields = block_given? ? yield : current_fields
      FieldUtils.first_field_by(*conditions, fields)
    end
  end
end
