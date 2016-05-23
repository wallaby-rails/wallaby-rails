module Wallaby::FormHelper
  def form_type_partial_render(options = {}, locals = {}, &block)
    form        = locals[:form]
    field_name  = locals[:field_name].to_s

    fail ArgumentError unless form.present? && field_name.present? && form.object.is_a?(Wallaby::ResourceDecorator)

    locals[:object]   = object = form.object
    locals[:metadata] = object.metadata_of locals[:field_name]
    locals[:value]    = object.public_send locals[:field_name]

    render(options, locals, &block) or render('string', locals, &block)
  end

  def model_choices(model_decorator)
    collection = model_servicer(model_decorator).collection Hash.new, current_ability
    decorate(collection).map do |decorated|
      [ decorated.to_label, decorated.primary_key_value ]
    end
  end
end
