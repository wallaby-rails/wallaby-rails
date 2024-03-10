# frozen_string_literal: true

module Wallaby
  # Deprecation log for methods
  class Deprecator
    include ActiveModel::Model

    # @!attribute method_instance
    # @return [Method]
    attr_accessor :method_instance
    # @!attribute from
    # @return [String]
    attr_accessor :from
    # @!attribute mod
    # @return [Class]
    attr_accessor :mod
    # @!attribute alternative
    # @return [Method]
    attr_accessor :alternative

    # Log an warning deprecation message or raise {MethodRemoved} when the given method is obsolete.
    # @param method_instance [Method] deprecated/obsolete method
    # @param from [String] from/since version
    # @param mod [Class] class name which has `VERSION` constants
    # @param alternative [Method] method to replace the deprecated/obsolete one
    # @see #alert
    def self.alert(method_instance, from:, mod: Core, alternative: nil)
      new(
        method_instance: method_instance, from: from, mod: mod, alternative: alternative
      ).alert
    end

    # @raise [MethodRemoved] when given method is obsolete
    def alert
      # if current version is larger than from version
      already = Gem::Version.new(mod_version) >= Gem::Version.new(from)
      raise MethodRemoved, obsolete_message if already

      Logger.warn deprecated_message, sourcing: 2
    end

    protected

    def obsolete_message
      "ERROR: #{full method_instance} is removed since #{mod_name} #{from}. #{alternative_message}"
    end

    def deprecated_message
      "DEPRECATED: #{full method_instance} will be removed from #{mod_name} #{from}. #{alternative_message}"
    end

    def alternative_message
      return "Please use #{full alternative} instead." if alternative.is_a? Method

      alternative.to_s
    end

    def mod_name
      return mod unless mod.is_a? Module

      mod.name.underscore.gsub SLASH, HYPHEN
    end

    def mod_version
      return mod unless mod.is_a? Module

      mod::VERSION
    end

    # @param method_instance [Method]
    # @return [String] `Class.class_method` or `Class#instance_method`
    def full(method_instance)
      return method_instance unless method_instance.is_a? Method

      owner = method_instance.owner
      is_klass_method = owner.singleton_class?
      klass = is_klass_method ? owner.to_s[8..-2] : owner.name
      "#{klass}#{is_klass_method ? DOT : HASH}#{method_instance.name}"
    end
  end
end
