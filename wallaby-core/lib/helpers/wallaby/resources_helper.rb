# frozen_string_literal: true

module Wallaby
  # Resources helper
  module ResourcesHelper
    include ApplicationHelper
    include SecureHelper

    include BaseHelper
    include FormHelper
    include IndexHelper

    include Authorizable
    include Decoratable
    include Paginatable
    include Resourcable
    include Servicable

    # @deprecated
    def type_render(_partial_name = '', _locals = {})
      Deprecator.alert method(__callee__), from: '0.3.0', alternative: <<~INSTRUCTION
        If it's for index type partils, please follow below example:

          render(
            field_name,
            object: decorated,
            field_name: field_name,
            value: decorated.try(field_name),
            metadata: decorated.index_metadata_of(field_name)
          )

        If it's for show type partils, please follow below example:

          render(
            field_name,
            object: decorated,
            field_name: field_name,
            value: decorated.try(field_name),
            metadata: decorated.show_metadata_of(field_name)
          )

        If it's for new/create/edit/update/destroy type partils, please follow below example:

          render(
            field_name,
            form: form,
            object: decorated,
            field_name: field_name,
            value: decorated.try(field_name),
            metadata: decorated.form_metadata_of(field_name)
          )

      INSTRUCTION
    end

    # Title for show page of given resource
    # @param decorated [ResourceDecorator]
    # @return [String]
    def show_title(decorated)
      unless decorated.is_a? ResourceDecorator
        raise ::ArgumentError, 'Please provide a resource wrapped by a decorator.'
      end

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
