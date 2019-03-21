module Wallaby
  # Custom form builder to add more helper functions
  class FormBuilder < ::ActionView::Helpers::FormBuilder
    # Return error class if there is error
    # @param field_name [String/Symbol]
    # @return [String]
    def error_class(field_name)
      'has-error' if object.errors[field_name].present?
    end

    # Build up the HTML for displaying error messages
    # @param field_name [String/Symbol]
    # @return [String] HTML
    def error_messages(field_name)
      errors = Array object.errors[field_name]
      return if errors.blank?

      content_tag :ul, class: 'errors' do
        errors.each do |message|
          concat content_tag :li, content_tag(:small, raw(message))
        end
      end
    end

    # Extend label to accept proc type `text` argument
    # @see ActionView::Helpers::FormBuilder#label
    def label(method, text = nil, options = {}, &block)
      text = instance_exec(&text) if text.is_a?(Proc)
      super
    end

    # Extend select to accept proc type `choices` argument
    # @see ActionView::Helpers::FormBuilder#select
    def select(method, choices = nil, options = {}, html_options = {}, &block)
      choices = instance_exec(&choices) if choices.is_a?(Proc)
      super
    end

    protected

    # Delegate missing method to `@template`
    def method_missing(method, *args, &block)
      return super unless @template.respond_to? method
      # Delegate the method so that we don't come in here the next time
      # when same method is called
      self.class.delegate method, to: :@template
      @template.public_send method, *args, &block
    end

    # Delegate missing method check to `@template`
    def respond_to_missing?(method, _include_private)
      @template.respond_to?(method) || super
    end
  end
end
