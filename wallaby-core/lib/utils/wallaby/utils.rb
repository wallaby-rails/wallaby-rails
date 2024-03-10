# frozen_string_literal: true

module Wallaby
  module Utils # :nodoc:
    # @param object [Object]
    # @return [Object] a cloned object
    def self.clone(object)
      # NOTE: Neither marshal/deep_dup/dup is able to make a correct deep copy,
      # therefore, this is our solution:
      case object
      when Hash
        HashCloner.execute(object)
      when Array
        object.each_with_object(object.class.new) { |value, array| array << clone(value) }
      when Class
        # NOTE: `Class.dup` turns the origin Class object into an anonymous clone.
        # therefore, the Class object itself should be returned instead
        object
      else
        object.dup
      end
    end

    # @param object [Object, nil]
    # @return [String] inspection string for the given object
    def self.inspect(object)
      return 'nil' if object.nil?
      return "#{object.class}##{object.try(:id)}" if object.is_a?(::ActiveRecord::Base)

      object.inspect
    end

    # Service object to clone Hash
    class HashCloner
      def self.execute(object)
        # NOTE: `default`/`default_proc` should be cloned as well
        default_method = object.default_proc ? :default_proc : :default
        object
          .each_with_object(object.class.new) { |(key, value), hash| hash[key] = Utils.clone(value) }
          .tap { |hash| hash.try("#{default_method}=", object.try(default_method)) }
      end
    end
  end
end
