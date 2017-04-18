module Wallaby
  # Form helper
  module FormHelper
    def form_type_partial_render(options = {}, locals = {}, &block)
      form        = locals[:form]
      field_name  = locals[:field_name].to_s

      form_type_partial_render_check(form, field_name)

      locals[:object]   = object = form.object
      locals[:metadata] = object.form_metadata_of locals[:field_name]
      locals[:value]    = object.public_send locals[:field_name]

      render(options, locals, &block) || render('string', locals, &block)
    end

    def model_choices(model_decorator)
      collection =
        model_servicer(model_decorator).collection({}, current_ability)
      decorate(collection).map do |decorated|
        [decorated.to_label, decorated.primary_key_value]
      end
    end

    protected

    def form_type_partial_render_check(form, field_name)
      unless form.present? && field_name.present? \
        && form.object.is_a?(Wallaby::ResourceDecorator)
        raise ArgumentError
      end
    end
  end
end
