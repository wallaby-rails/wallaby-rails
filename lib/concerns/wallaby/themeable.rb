module Wallaby
  # Theme related methods
  module Themeable
    # Configurable attributes
    module ClassMethods
      # @!attribute [w] theme_name
      def theme_name=(theme_name)
        layout theme_name
        @theme_name = theme_name
      end

      # @!attribute [r] theme_name
      # The theme name is used to apply a set of frontend (html/css/javascript) implementation.
      #
      # When theme name is set to e.g. `custom_theme`, the following changes will be made:
      #
      # - layout will be set to the same name `custom_theme`
      # - it will be added to the partial lookup prefixes right on top of `wallaby/resources` prefix.
      #
      # Once theme name is set, all its controller subclasses will inherit the same theme name
      # @example To set an theme name:
      #   class Admin::ApplicationController < Wallaby::ResourcesController
      #     self.theme_name = 'admin_theme'
      #   end
      # @return [String, Symbol, nil] theme name
      # @since 5.2.0
      def theme_name
        @theme_name ||= ModuleUtils.try_to superclass, :theme_name
      end
    end

    # @return [String, Symbol, nil] theme name
    # @since 5.2.0
    def current_theme_name
      controller_to_get __callee__, :theme_name
    end
  end
end
