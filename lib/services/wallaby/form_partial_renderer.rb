module Wallaby
  # Form partial builder
  class FormPartialRenderer
    class << self
      # Render form partial
      # @param options [String] partial name
      # @param locals [Hash]
      # @return [String] HTML
      def render(helper, options = {}, locals = {}, &block)
        form = locals[:form]
        field_name = locals[:field_name].to_s

        valid? form, field_name

        object = locals[:object] = form.object
        locals[:metadata] = object.form_metadata_of locals[:field_name]
        locals[:value] = object.public_send locals[:field_name]

        helper.render(options, locals, &block) \
          || helper.render('string', locals, &block)
      end

      private

      def valid?(form, field_name)
        raise ArgumentError, 'Form is required.' if form.blank?
        raise ArgumentError, 'Field name is required.' if field_name.blank?
        raise ArgumentError, 'Object is not decorated.' \
          unless form.object.is_a? ResourceDecorator
      end
    end
  end
end
