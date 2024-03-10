# frozen_string_literal: true

module Wallaby
  module View
    # Theme module to allow layout and prefixes to be specified.
    module Themeable
      extend ActiveSupport::Concern

      module ClassMethods # :nodoc:
        # The theme name is used to specify the layout and prefixes
        # so that a set of theme implementation for the frontend (html/css/javascript)
        # can be applied
        #
        # When theme name is set to e.g. `custom_theme`,
        # the following changes will be made:
        #
        # - layout will be set to the same name `custom_theme`
        # - theme name will be added to the lookup prefixes
        #   right after the controller path of where it's defined.
        #
        # Once theme name is set, all its subclass controllers
        # will inherit the same theme name
        # @example To set an theme name:
        #   class Admin::ApplicationController < ApplicationController
        #     self.theme_name = 'secure'
        #
        #     def index
        #       _prefixes
        #
        #       # =>
        #       # [
        #       #   'admin/application/index',
        #       #   'admin/application',
        #       #   'secure/index',
        #       #   'secure',
        #       #   'application/index',
        #       #   'application'
        #       # ]
        #     end
        #   end
        # @param theme_name [String]
        # @param options [Hash] same options as Rails'
        #   {https://api.rubyonrails.org/classes/ActionView/Layouts/ClassMethods.html#method-i-layout
        #   layout} method
        def theme_name=(theme_name, **options, &block)
          layout theme_name, options, &block
          @theme_path = (theme_name && controller_path) || nil
          @theme_name = theme_name || nil
        end

        # @!attribute [r] theme_name
        # @return [String, nil] theme name
        def theme_name
          (defined?(@theme_name) && @theme_name) || superclass.try(:theme_name)
        end

        # @!attribute [r] theme
        # @example Once theme is set, the metadata will be set as well:
        #   class Admin::ApplicationController < ApplicationController
        #     self.theme_name = 'secure'
        #
        #     self.theme
        #
        #     # =>
        #     # {
        #     #   theme_name: 'secure',
        #     #   theme_path: 'admin/application'
        #     # }
        #   end
        # @return [Hash] theme metadata
        def theme
          (defined?(@theme_name) && @theme_name && {
            theme_name: @theme_name,
            theme_path: @theme_path
          }) || superclass.try(:theme)
        end

        # @!attribute [r] themes
        # @return [Array<Hash>] a list of {#theme} metadata
        def themes
          list = superclass.try(:themes) || []
          list.prepend theme if defined?(@theme_name) && @theme_name
          list.compact
        end
      end
    end
  end
end
