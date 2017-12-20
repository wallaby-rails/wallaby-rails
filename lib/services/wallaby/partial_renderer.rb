module Wallaby
  # Partial renderer
  class PartialRenderer
    class << self
      # Render form partial
      # @param options [String] partial name
      # @param locals [Hash]
      # @return [String] HTML
      def render(helper, options = {}, locals = {}, action_name = nil, &block)
        decorated = locals[:object]
        field_name = locals[:field_name].to_s
        action_name ||= Utils.to_partial_name helper.params[:action]

        partial_arguments_check decorated, field_name

        locals[:metadata] =
          decorated.public_send :"#{action_name}_metadata_of", field_name
        locals[:value] = decorated.public_send field_name

        helper.render(options, locals, &block) \
          || helper.render('string', locals, &block)
      end

      # Render form partial
      # @param helper [ActionView] view
      # @param options [String] partial name
      # @param locals [Hash]
      # @return [String] HTML
      def render_form(helper, options = {}, locals = {}, &block)
        form = locals[:form]
        field_name = locals[:field_name].to_s

        form_arguments_check form, field_name

        decorated = locals[:object] = form.object
        locals[:metadata] = decorated.form_metadata_of locals[:field_name]
        locals[:value] = decorated.public_send locals[:field_name]

        helper.render(options, locals, &block) \
          || helper.render('string', locals, &block)
      end

      private

      def partial_arguments_check(object, field_name)
        raise ArgumentError, 'Field name is required.' if field_name.blank?
        raise ArgumentError, 'Object is not decorated.' \
          unless object.is_a? ResourceDecorator
      end

      def form_arguments_check(form, field_name)
        raise ArgumentError, 'Form is required.' if form.blank?
        raise ArgumentError, 'Field name is required.' if field_name.blank?
        raise ArgumentError, 'Object is not decorated.' \
          unless form.object.is_a? ResourceDecorator
      end
    end
  end
end
