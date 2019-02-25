module Wallaby
  # Utils
  module Utils
    def self.deprecate(key, caller:, options: {})
      warn I18n.t(key, options.merge(from: caller[0]))
    end

    # Help to translate a message for a class
    # @param object [Object]
    # @param key [String, Symbol]
    # @param options [Hash]
    # @return [String] a message for this class
    def self.translate_class(object, key, options = {})
      klass = object.is_a?(Class) ? object : object.class
      key = [klass.name, key].join(SLASH).underscore.gsub(SLASH, DOT)
      I18n.t key, options
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
      FORM_ACTIONS[action_name] || action_name
    end

    # @see http://stackoverflow.com/a/8710663/1326499
    # @param object [Object]
    # @return [Object] a clone object
    def self.clone(object)
      ::Marshal.load(::Marshal.dump(object))
    end
  end
end
