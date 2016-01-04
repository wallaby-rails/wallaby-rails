# NOTE: Global helper methods should go in here
module Wallaby::CoreHelper
  def body_class
    [
      params[:action],
      resources_name.try(:gsub, '::', '__'),
      content_for(:custom_body_class)
    ].compact.join ' '
  end

  def page_title
    ct('page.title', default: false) || 'Wallaby::Admin'
  end

  def current_model_label
    label = 'Resources'
    if resources_name.present?
      label << ': ' << content_tag(:strong, (Wallaby::Utils.try do |util|
        util.to_model_label util.to_model_name(resources_name)
      end))
    end
    label.html_safe
  end

  def link_to_model(model)
    decorator = model_decorator model
    name      = Wallaby::Utils.to_resources_name model
    link_to decorator.model_label, wallaby_engine.resources_path(name)
  end

  def ct(key, options = {})
    # TODO: review this when we are going to replace all plain text with I18n translation
    @custom_translation ||= {}
    if @custom_translation.has_key? key
      @custom_translation[key]
    else
      @custom_translation[key] = t key, { raise: true }.merge(options)
    end
  rescue I18n::MissingTranslationData => e
    keys = I18n.normalize_keys(e.locale, e.key, e.options[:scope])
    @custom_translation[key] = keys.last.to_s.titleize
  end
end