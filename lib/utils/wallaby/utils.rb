module Wallaby
  # Utils
  module Utils
    def self.to_resources_name(model_class)
      return EMPTY_STRING if model_class.blank?
      model_class.to_s.underscore.gsub(SLASH, COLONS).pluralize
    end

    def self.to_model_label(model_class)
      return EMPTY_STRING if model_class.blank?
      model_class_name = to_model_name model_class
      model_class_name.titleize.gsub(SLASH, SPACE + SLASH + SPACE)
    end

    def self.to_model_name(resources_name)
      return EMPTY_STRING if resources_name.blank?
      resources_name.to_s.singularize.gsub(COLONS, SLASH).camelize
    end

    def self.to_model_class(resources_name)
      return if resources_name.blank?
      class_name = to_model_name resources_name
      # NOTE: do not use if statement instead of rescue here
      # we want the class_name to be eagerly loaded
      class_name.constantize
    rescue NameError => _error
      raise ModelNotFound, class_name
    end

    def self.find_filter_name(filter_name, filters)
      filter_name || # from params
        filters.find{ |k, v| v[:default] }.try(:first) || # from default value
        :all # last resort
    end

    def self.to_hash(array)
      Hash[*array.flatten(1)]
    end

    # @see http://stackoverflow.com/a/8710663/1326499
    def self.clone(object)
      ::Marshal.load(::Marshal.dump(object))
    end
  end
end
