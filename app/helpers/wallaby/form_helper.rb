module Wallaby::FormHelper
  def form_type_partial_render(options = {}, locals = {}, &block)
    fail ArgumentError unless %i( form field_name ).all?{ |key| locals.has_key? key } && locals[:form].object.is_a?(Wallaby::ResourceDecorator)
    options = "form/#{ options }" if options.is_a? String
    locals[:object] = locals[:form].object
    locals[:value] = locals[:object].send locals[:field_name]
    locals[:metadata] = locals[:object].metadata_of locals[:field_name]
    render options, locals, &block or
      default_rendered = \
        case options.to_s
        when 'text'
          locals[:form].text_area locals[:field_name], class: 'form-control'
        else
          locals[:form].text_field locals[:field_name], class: 'form-control'
        end
  end

  def form_field_error_messages(decorated_resource, field_name)
    content_tag :ul, class: 'text-danger' do
      Array(decorated_resource.errors[field_name]).map do |message|
        content_tag :li, content_tag(:small, raw(message))
      end.join.html_safe
    end
  end

  def model_choices(this_model_decorator)
    choices = this_model_decorator.search.map do |item|
      decorated = decorate item
      [ decorated.to_label, decorated.send(decorated.primary_key) ]
    end
  end
end
