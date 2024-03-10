# frozen_string_literal: true

module Wallaby
  module View
    # Custom lookup context to cache lookup results.
    class CustomLookupContext < ::ActionView::LookupContext
      # Convert an ActionView::LookupContext instance into {CustomLookupContext}
      # @param lookup_context [ActionView::LookupContext]
      # @param details [Hash]
      # @param prefixes [Array<String>]
      # @return [CustomLookupContext]
      def self.convert(lookup_context, details: nil, prefixes: nil)
        return lookup_context if lookup_context.is_a? self

        new(
          lookup_context.view_paths,
          details || lookup_context.instance_variable_get(:@details),
          prefixes || lookup_context.prefixes
        )
      end

      # @!method original_find(path, prefixes, partial, *args)
      # Original find method.
      # @param path [String, Symbol]
      # @param prefixes [Array<String>]
      # @param partial [true, false]
      # @param args [Array] the rest of the arguments
      # @return [ActionView::Template]
      alias_method :original_find, :find

      # This is to resolve the performance bottleneck for template/partial lookup.
      #
      # {#cached_lookup} is used to cache the lookup result throughout a request.
      # @param path [String, Symbol]
      # @param prefixes [Array<String>]
      # @param partial [true, false]
      # @param args [Array] the rest of the arguments
      # @return [ActionView::Template]
      def find(path, prefixes, partial, *args)
        key = [path, prefixes, partial].join(EQUAL)
        cached_lookup[key] ||= original_find(path, prefixes, partial, *args)
      end

      # @!method find_template(path, prefixes, partial, *args)
      # This is an alias method of {#find}
      # (see #find)
      alias_method :find_template, :find

      protected

      # @!attribute [r] cached_lookup
      # This is a lookup cache for method {#find}
      # @return [Hash] prefix options
      def cached_lookup
        @cached_lookup ||= {}
      end
    end
  end
end
