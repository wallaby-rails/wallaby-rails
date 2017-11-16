module Wallaby
  # Custom form builder to add more helper functions
  class FormBuilder < ::ActionView::Helpers::FormBuilder
    def error_class(field_name)
      'has-error' if error? field_name
    end

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
    def label(method, text = nil, options = {}, &block)
      text = instance_exec(&text) if text.respond_to? :call
      super
    end

    # Extend select to accept proc type `choices` argument
    def select(method, choices = nil, options = {}, html_options = {}, &block)
      choices = instance_exec(&choices) if choices.respond_to? :call
      super
    end

    protected

    def method_missing(method, *args, &block)
      return super unless @template.respond_to? method
      self.class.delegate method, to: :@template
      @template.public_send method, *args, &block
    end

    def respond_to_missing?(method, _include_private)
      @template.respond_to?(method) || super
    end

    def error?(field_name)
      object.errors[field_name].present?
    end
  end
end
