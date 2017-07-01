require 'securerandom'

module Wallaby
  # NOTE: Global helper methods should go in here
  module CoreHelper
    include StylingHelper
    include LinksHelper

    def to_model_label(model_class)
      Utils.to_model_label model_class
    end

    def to_resources_name(model_class)
      Map.resources_name_map model_class
    end

    def body_class
      [
        params[:action],
        current_resources_name.try(:gsub, COLONS, '__'),
        content_for(:custom_body_class)
      ].compact.join SPACE
    end

    def ct(key, options = {})
      t key, { raise: true }.merge(options)
    rescue ::I18n::MissingTranslationData => e
      keys = ::I18n.normalize_keys(e.locale, e.key, e.options[:scope])
      keys.last.to_s.titleize
    end

    def random_uuid
      SecureRandom.uuid
    end

    def model_classes
      Map.model_classes.sort_by(&:name)
    end
  end
end
