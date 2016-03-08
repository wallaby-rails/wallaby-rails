module Wallaby::FormHelper
  def form_type_partial_render(options = {}, locals = {}, &block)
    form        = locals[:form]
    field_name  = locals[:field_name].to_s

    fail ArgumentError unless form.present? && field_name.present? && form.object.is_a?(Wallaby::ResourceDecorator)

    options = "form/#{ options }" if options.is_a? String

    locals[:object]   = object = form.object
    locals[:metadata] = object.metadata_of locals[:field_name]
    locals[:value]    = object.send locals[:field_name]

    render(options, locals, &block) or render('form/string', locals, &block)
  end

  def form_group_classes(decorated, field_name)
    styles = []
    styles << 'has-error' if decorated.errors[field_name].present?
    styles.join ' '
  end

  def form_field_error_messages(decorated, field_name)
    content_tag :ul, class: 'text-danger' do
      Array(decorated.errors[field_name]).each do |message|
        concat content_tag :li, content_tag(:small, raw(message))
      end
    end
  end

  def model_choices(model_decorator)
    decorate(model_decorator.collection).map do |decorated|
      [ decorated.to_label, decorated.send(decorated.primary_key) ]
    end
  end
end
