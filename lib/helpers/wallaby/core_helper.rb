require 'securerandom'

module Wallaby
  # NOTE: Global helper methods should go in here
  module CoreHelper
    include Wallaby::StylingHelper
    include Wallaby::LinksHelper

    def to_model_label(model_class)
      Wallaby::Utils.to_model_label model_class
    end

    def to_resources_name(model_class)
      Map.resources_name_map model_class
    end

    def current_model_label
      if current_resources_name.present?
        label = to_model_label current_resources_name
        return "Resource: #{label}" if label.present?
      end
      'Resources'
    end

    def body_class
      [
        params[:action],
        current_resources_name.try(:gsub, COLONS, '__'),
        content_for(:custom_body_class)
      ].compact.join SPACE
    end

    def page_title
      'Wallaby::Admin'
    end

    def ct(key, options = {})
      t key, { raise: true }.merge(options)
    rescue I18n::MissingTranslationData => e
      keys = I18n.normalize_keys(e.locale, e.key, e.options[:scope])
      keys.last.to_s.titleize
    end

    def random_uuid
      SecureRandom.uuid
    end

    def model_classes
      Wallaby::Map.model_classes.sort_by(&:name)
    end
  end
end
