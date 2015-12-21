module Wallaby::CoreHelper
  def body_class
    [
      action_name,
      (resources_name || '').gsub('::', '__'),
      content_for(:custom_body_class)
    ].compact.join ' '
  end

  # override `actionview/lib/action_view/helpers/rendering_helper.rb#render`
  def render options = {}, locals = {}, &block
    caller_view_path = File.dirname caller[0].gsub(%r(:.*\Z), '')
    view_paths << caller_view_path
    super options, locals, &block
  end

  def link_to_model model
    decorator = model_decorator model
    name      = Wallaby::Utils.to_resources_name model.to_s
    link_to decorator.model_label, wallaby_engine.resources_path(name)
  end

  def page_title
    ct('page.title', default: false) || 'Wallaby::Admin'
  end

  def ct key, options = {}
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