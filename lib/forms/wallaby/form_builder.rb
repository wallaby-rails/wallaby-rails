module Wallaby
  # Form builder
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

    def label(method, text = nil, options = {}, &block)
      text = text.yield if text.respond_to? :yield
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
