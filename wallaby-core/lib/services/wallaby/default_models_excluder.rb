# frozen_string_literal: true

module Wallaby
  # see {.execute}
  class DefaultModelsExcluder
    class << self
      # {Wallaby} excludes the following model classes by default.
      #
      # - ActiveRecord::SchemaMigration
      # - ActiveRecord::InternalMetadata
      # @return [ClassArray] a list of model classes
      def execute
        ClassArray.new(
          [].tap do |list|
            list << active_record_schema_migration_class
            list << active_record_internal_metadata_class
          end.compact
        )
      end

      private

      # @return [Class] if Wallaby knows about `ActiveRecord::SchemaMigration`
      # @return [nil] otherwise
      def active_record_schema_migration_class
        exists =
          defined?(::ActiveRecord::SchemaMigration) \
            && Map.mode_map.key?(::ActiveRecord::SchemaMigration)

        exists ? ::ActiveRecord::SchemaMigration : nil
      end

      # NOTE: `ActiveRecord::InternalMetadata` exists since Rails 6.0
      # @return [Class] if Wallaby knows about `ActiveRecord::InternalMetadata`
      # @return [nil] otherwise
      def active_record_internal_metadata_class
        exists =
          defined?(::ActiveRecord::InternalMetadata) \
            && Map.mode_map.key?(::ActiveRecord::InternalMetadata)

        exists ? ::ActiveRecord::InternalMetadata : nil
      end
    end
  end
end
