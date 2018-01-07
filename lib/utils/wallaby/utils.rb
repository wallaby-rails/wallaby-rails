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
        filters.find { |_k, v| v[:default] }.try(:first) || # from default value
        :all # last resort
    end

    def self.to_field_label(field_name, metadata)
      field_name = field_name.to_s if field_name.is_a? Symbol
      metadata[:label] || field_name.humanize
    end

    def self.to_partial_name(action_name)
      FORM_ACTIONS.include?(action_name) ? 'form' : action_name
    end

    def self.to_hash(array)
      Hash[*array.flatten(1)]
    end

    # @see http://stackoverflow.com/a/8710663/1326499
    def self.clone(object)
      ::Marshal.load(::Marshal.dump(object))
    end

    def self.preload_all
      ::Wallaby::ApplicationController.to_s
      preload 'app/models/**/*.rb'
      preload 'app/decorators/**/*.rb'
      preload 'app/controllers/**/*.rb'
      preload 'app/servicers/**/*.rb'
      preload 'app/**/*.rb'
    end

    def self.preload(file_pattern)
      Dir[file_pattern].each do |file_path|
        begin
          name = file_path[%r{app/[^/]+/(.+)\.rb}, 1].gsub('concerns/', '')
          class_name = name.classify
          class_name.constantize unless Module.const_defined? class_name
        rescue NameError, LoadError => e
          Rails.logger.debug ">>>>>>>>> PRELOAD ERROR: #{e.message}"
          Rails.logger.debug e.backtrace.slice(0, 5)
        end
      end
    end
  end
end
