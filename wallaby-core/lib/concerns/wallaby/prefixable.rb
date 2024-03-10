# frozen_string_literal: true

module Wallaby
  # Field helper for model decorator
  module Prefixable
    extend ActiveSupport::Concern

    MAPPING_ACTIONS = {
      new: 'form',
      create: 'form',
      edit: 'form',
      update: 'form'
    }.freeze

    module ClassMethods
      attr_writer :mapping_actions

      def mapping_actions
        @mapping_actions || superclass.try(:mapping_actions) || MAPPING_ACTIONS
      end

      def add_mapping_actions(options)
        @mapping_actions = mapping_actions.merge(options)
      end
    end

    # @return [Array<String>] prefixes
    def wallaby_prefixes
      override_prefixes(
        options: { mapping_actions: self.class.mapping_actions }
      ) do |prefixes|
        PrefixesBuilder.new(
          controller_class: self.class,
          prefixes: prefixes,
          resources_name: current_resources_name,
          script_name: request.env[SCRIPT_NAME]
        ).execute
      end
    end
  end
end
