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

    def model_choices(model_class)
      warn '[DEPRECATION] `model_choices` will be removed in version 5.2.0.'
      collection = model_servicer(model_class).collection({})
      decorate(collection).map do |decorated|
        [decorated.to_label, decorated.primary_key_value]
      end
    end

    def form_type_partial_render_check(form, field_name)
      unless form.present? && field_name.present? \
        && form.object.is_a?(ResourceDecorator)
        raise ArgumentError
      end
    end

    def remote_url(url, model_class, wildcard = 'QUERY')
      url || begin
        url_params = { q: wildcard, per: Wallaby.configuration.page_size }
        index_path(model_class: model_class, url_params: url_params)
      end
    end

    def polymorphic_options(metadata, wildcard = 'QUERY', select_options = {})
      urls = metadata[:remote_urls] || {}
      options = metadata[:polymorphic_list].try :map do |klass|
        [
          klass, klass,
          { data: { url: remote_url(urls[klass], klass, wildcard) } }
        ]
      end
      options_for_select options, select_options
    end
  end
end
