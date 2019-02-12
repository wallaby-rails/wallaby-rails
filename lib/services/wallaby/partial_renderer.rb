module Wallaby
  # @!visibility private
  # Partial renderer
  class PartialRenderer
    class << self
      # Render partial
      # @param view [ActionView]
      # @param options [Hash]
      # @param locals [Hash]
      # @return [String] HTML
      def render(view, options = {}, locals = {}, &block)
        locals[:object] ||= locals[:form].try :object
        check locals
        complete locals, view.params[:action]
        partial = find_partial options, view

        if cell? partial
          render_cell partial, locals, view, &block
        else
          view.render options, locals, &block
        end
      end

      private

      # @param locals [Hash]
      # @raise [ArgumentError] if form is set but blank
      # @raise [ArgumentError] if field_name is not provided
      # @raise [ArgumentError] if object is not decorated
      def check(locals)
        raise ArgumentError, I18n.t('errors.required', subject: 'form') if locals.key?(:form) && locals[:form].blank?
        raise ArgumentError, I18n.t('errors.required', subject: 'field_name') if locals[:field_name].blank?
        raise ArgumentError, 'Object is not decorated.' unless locals[:object].is_a? ResourceDecorator
      end

      # @param locals [Hash]
      # @param action [String]
      def complete(locals, action)
        action_name = Utils.to_partial_name action
        locals[:metadata] = locals[:object].public_send :"#{action_name}_metadata_of", locals[:field_name]
        locals[:value] = locals[:object].public_send locals[:field_name]
      end

      # @param options [String]
      # @param view [ActionView]
      # @return [String] partial path string
      # @return [String] blank string
      def find_partial(options, view)
        formats = [view.request.format.to_sym]
        lookup = view.custom_lookup_context
        lookup.find_template options, lookup.prefixes, true, [], formats: formats
      end

      # @param partial [String]
      # @return [true] if partial ends with `.rb`
      # @return [false] otherwise
      def cell?(partial)
        partial.inspect.end_with? '.rb'
      end

      # @param partial [String]
      # @param locals [Hash]
      # @param view [ActionView]
      def render_cell(partial, locals, view, &block)
        file_name = partial.inspect[%r{(?<=/app/).+(?=\.rb)}].split('/', 2).last
        cell_class = file_name.camelize.constantize
        Rails.logger.debug "  Rendered [cell] #{partial.inspect}"
        cell_class.new(view, locals).render_complete(&block)
      end
    end
  end
end
