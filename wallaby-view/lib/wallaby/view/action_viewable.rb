# frozen_string_literal: true

module Wallaby
  module View
    # This module overrides Rails core methods {#lookup_context} and {#_prefixes}
    # to provide better performance and more lookup prefixes.
    module ActionViewable
      extend ActiveSupport::Concern

      module ClassMethods # :nodoc:
        # @!attribute [w] prefix_options
        attr_writer :prefix_options

        # @!attribute [r] prefix_options
        # It stores the options for {#_prefixes #_prefixes}. It can inherit options from superclass.
        # @return [Hash] prefix options
        def prefix_options
          @prefix_options ||= superclass.try(:prefix_options).try(:dup) || {}
        end

        # Add prefix options
        # @param new_options [Hash]
        # @return [Hash] merged prefix options
        def merge_prefix_options(new_options)
          prefix_options.merge!(new_options)
        end
      end

      # @!method original_lookup_context
      # Original method of {#lookup_context}
      # @return [ActionView::LookupContext]

      # @!method original_prefixes
      # Original method of {#_prefixes}
      # @return [Array<String>]

      # @!method lookup_context
      # Override
      # {https://github.com/rails/rails/blob/master/actionview/lib/action_view/view_paths.rb#L97 lookup_context}
      # to provide caching for template/partial lookup.
      # @return {CustomLookupContext}

      # (see #lookup_context)
      def override_lookup_context
        @_lookup_context ||=
          CustomLookupContext.convert(original_lookup_context, prefixes: _prefixes)
      end

      # @!method _prefixes(prefixes: nil, controller_path: nil, action_name: nil, themes: nil, options: nil, &block)
      # Override {https://github.com/rails/rails/blob/master/actionview/lib/action_view/view_paths.rb#L90 _prefixes}
      # to allow other (e.g. {CustomPrefixes#action_name},
      # {CustomPrefixes#themes}) to be added to the prefixes list.
      # @param prefixes [Array<String>] the base prefixes
      # @param action_name [String] the action name to add to the prefixes list
      # @param themes [String] the theme name to add to the prefixes list
      # @param options [Hash] the options that {CustomPrefixes} accepts
      # @return [Array<String>]

      # (see #_prefixes)
      def override_prefixes(
        prefixes: nil,
        action_name: nil,
        themes: nil,
        options: nil, &block
      )
        @_prefixes ||=
          CustomPrefixes.execute(
            prefixes: prefixes || original_prefixes,
            action_name: action_name || params[:action],
            themes: themes || self.class.themes,
            options: self.class.prefix_options.merge(options || {}), &block
          )
      end
    end
  end
end
