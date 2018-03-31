module Wallaby
  # Utils
  module Utils
    # @param klass [Class]
    # @return [Boolean] whether a class is anonymous
    def self.anonymous_class?(klass)
      klass.name.blank? || klass.to_s.start_with?('#<Class')
    end

    # Help to translate a message for a method and its class
    # @param object [Object]
    # @param method_id [Symbol]
    # @param options [Hash]
    # @return [String] a message for this method and its class
    def self.t(object, method_id, options = {})
      klass = object.is_a?(Class) ? object : object.class
      key = [klass.name, method_id].join(SLASH).underscore.gsub(SLASH, DOT)
      I18n.t key, options
    end

    # Convert model class (e.g. `Namespace::Product`) into resources name
    # (e.g. `namespace::products`)
    # @param model_class [Class, String] model class
    # @return [String] resources name
    def self.to_resources_name(model_class)
      return EMPTY_STRING if model_class.blank?
      model_class.to_s.underscore.gsub(SLASH, COLONS).pluralize
    end

    # Convert model class (e.g. `Namespace::Product`) into model label
    # (e.g. `Namespace / Product`)
    # @param model_class [Class, String] model class
    # @return [String] model label
    def self.to_model_label(model_class)
      return EMPTY_STRING if model_class.blank?
      model_class_name = to_model_name model_class
      model_class_name.titleize.gsub(SLASH, SPACE + SLASH + SPACE)
    end

    # Convert resources name (e.g. `namespace::products`) into model name
    # (e.g. `Namespace::Product`)
    # @param resources_name [String] resources name
    # @return [String] model name
    def self.to_model_name(resources_name)
      return EMPTY_STRING if resources_name.blank?
      resources_name.to_s.singularize.gsub(COLONS, SLASH).camelize
    end

    # Convert resources name (e.g. `namespace::products`) into model class
    # (e.g. `Namespace::Product`)
    # @param resources_name [String] resources name
    # @return [Class] model class
    def self.to_model_class(resources_name)
      return if resources_name.blank?
      class_name = to_model_name resources_name
      # NOTE: do not use if statement instead of rescue here
      # we want the class_name to be eagerly loaded
      class_name.constantize
    rescue NameError => _error
      raise ModelNotFound, class_name
    end

    # Find filter name in the following precedences:
    # - filter name argument
    # - filters that has been marked as default
    # - `:all`
    # @param filter_name [String, Symbol] filter name
    # @param filters [Hash] filter metadata
    # @return [String, Symbol]
    def self.find_filter_name(filter_name, filters)
      filter_name || # from params
        filters.find { |_k, v| v[:default] }.try(:first) || # from default value
        :all # last resort
    end

    # @todo maybe delegate this label thing to the mode?
    # @param field_name [String, Symbol] field name
    # @return [String] field label
    def self.to_field_label(field_name, metadata)
      field_name = field_name.to_s if field_name.is_a? Symbol
      metadata[:label] || field_name.humanize
    end

    # Return `form` for `new/create/edit/update`
    # @param action_name [String]
    # @return [String] action name
    def self.to_partial_name(action_name)
      FORM_ACTIONS.include?(action_name) ? 'form' : action_name
    end

    # @see http://stackoverflow.com/a/8710663/1326499
    # @param object [Object]
    # @return [Object] a clone object
    def self.clone(object)
      ::Marshal.load(::Marshal.dump(object))
    end

    # Preload files
    def self.preload_all
      ::Wallaby::ApplicationController.to_s
      preload 'app/models/**/*.rb'
      preload 'app/decorators/**/*.rb'
      preload 'app/controllers/**/*.rb'
      preload 'app/servicers/**/*.rb'
      preload 'app/**/*.rb'
    end

    # Preload files
    def self.preload(file_pattern)
      Dir[file_pattern].each do |file_path|
        begin
          name = file_path[%r{app/[^/]+/(.+)\.rb}, 1].gsub('concerns/', '')
          class_name = name.classify
          class_name.constantize unless Module.const_defined? class_name
        rescue NameError, LoadError => e
          Rails.logger.debug "  [WALLABY] Preload warning: #{e.message}"
          Rails.logger.debug e.backtrace.slice(0, 5)
        end
      end
    end
  end
end
