# frozen_string_literal: true

module Wallaby
  module View
    # Custom prefix builder to add more lookup prefix paths to given {#prefixes}.
    class CustomPrefixes
      # @!attribute [r] prefixes
      # Base prefixes to extend
      # @return [Array<String>]
      # @see ActionViewable#_prefixes
      attr_reader :prefixes

      # @!attribute [r] action_name
      # Action name to be added
      # @return [String]
      attr_reader :action_name

      # @!attribute [r] themes
      # Themes to be inserted
      # @return [Array<Hash>]
      # @see Themeable#.themes
      attr_reader :themes

      # @!attribute [r] options
      # Options for extending the given prefixes
      # @return [Hash]
      attr_reader :options

      # Extend given prefixes with action name and theme name
      # @example To extend given prefixes:
      #   Wallaby::View::CustomPrefixes.execute(
      #     prefixes: ['users', 'application'], action_name: 'index'
      #   )
      #
      #   # => [
      #   #   'users/index',
      #   #   'users',
      #   #   'application/index',
      #   #   'application'
      #   # ]
      # @example To extend given prefixes with themes:
      #   Wallaby::View::CustomPrefixes.execute(
      #     prefixes: ['users', 'application'], action_name: 'index',
      #     themes: [{ theme_name: 'secure', theme_path: 'users' }]
      #   )
      #
      #   # => [
      #   #   'users/index',
      #   #   'users',
      #   #   'secure/index',
      #   #   'secure',
      #   #   'application/index',
      #   #   'application'
      #   # ]
      # @example To extend given prefixes with mapped action:
      #   Wallaby::View::CustomPrefixes.execute(
      #     prefixes: ['users', 'application'], action_name: 'edit',
      #     options: { 'edit' => 'form' }
      #   )
      #
      #   # => [
      #   #   'users/form',
      #   #   'users',
      #   #   'application/form',
      #   #   'application'
      #   # ]
      # @param prefixes [Array<String>]
      # @param action_name [String]
      # @param themes [String, nil]
      # @param options [Hash, nil]
      # @return [Array<String>]
      def self.execute(
        prefixes:, action_name:, themes: nil, options: nil, &block
      )
        new(
          prefixes: prefixes, action_name: action_name,
          themes: themes, options: options
        ).execute(&block)
      end

      # Create the instance
      # @param prefixes [Array<String>]
      # @param action_name [String]
      # @param themes [String]
      # @param options [Hash]
      def initialize(prefixes:, action_name:, themes:, options:)
        @prefixes = prefixes
        @action_name = action_name
        @themes = themes
        @options = (options || {}).with_indifferent_access
      end

      # Extend given prefixes with action name and theme name
      # @return [Array<String>]
      def execute(&block)
        new_prefixes(&block).each_with_object([]) do |prefix, array|
          # Extend the prefix with actions
          actions.each { |action| array << "#{prefix}/#{action}" }
          array << prefix
        end
      end

      protected

      # @yield [array] To allow the array to be further modified
      # @yieldparam [Array<String>] array
      # @return [Array<String>]
      def new_prefixes
        prefixes.dup.try do |array|
          insert_themes_into array

          # Be able to change the array in overriding methods
          # in {ActionViewable#override_prefixes}
          new_array = yield array if block_given?

          # If the above block doesn't return a new array, it returns the old `array`.
          new_array.is_a?(Array) ? new_array : array
        end
      end

      # @return [Array<String>] Action names
      def actions
        @actions ||= [action_name, *mapped_action_name].compact
      end

      # Insert theme names into the prefixes
      # @param [Array<String>] array
      def insert_themes_into(array)
        themes.each do |theme|
          index = array.index theme[:theme_path]
          array.insert(index + 1, theme[:theme_name]) if index
        end
      end

      # Map the {#action_name} using `options[:mapping_actions]`
      # @return [Array<String>] mapped action name
      def mapped_action_name
        Array.wrap((options[:mapping_actions] || options).try(:[], action_name))
      end
    end
  end
end
