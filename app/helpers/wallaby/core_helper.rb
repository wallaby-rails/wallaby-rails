# NOTE: Global helper methods should go in here
module Wallaby::CoreHelper
  include Wallaby::StylingHelper
  include Wallaby::LinksHelper

  def current_model_label
    if current_resources_name.present?
      model_label = Wallaby::Utils.to_model_label current_resources_name
      return "Resource: #{ model_label }" if model_label.present?
    end
    'Resources'
  end

  def body_class
    [
      params[:action],
      current_resources_name.try(:gsub, '::', '__'),
      content_for(:custom_body_class)
    ].compact.join ' '
  end

  def page_title
    'Wallaby::Admin'
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

  def random_uuid
    SecureRandom.uuid
  end

  def model_classes
    @model_classes ||= Wallaby.configuration.adaptor.model_finder.new.available
  end
end
