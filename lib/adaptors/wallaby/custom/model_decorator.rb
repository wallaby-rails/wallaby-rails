module Wallaby
  class Custom
    # Custom modal decorator
    class ModelDecorator < ::Wallaby::ModelDecorator
      # Assume that attributes come from the setter/getter, e.g. `name=`/`name`
      # @return [ActiveSupport::HashWithIndifferentAccess] metadata
      def fields
        @fields ||=
          ::ActiveSupport::HashWithIndifferentAccess.new.tap do |hash|
            methods = model_class.public_instance_methods(false).map(&:to_s)
            methods
              .grep(/[^=]$/)
              .select { |method_id| methods.include? "#{method_id}=" }
              .each { |attribute| hash[attribute] = { label: attribute.humanize, type: 'string' } }
          end.freeze
      end

      # A copy of {#fields} for index page
      # @return [ActiveSupport::HashWithIndifferentAccess] metadata
      def index_fields
        @index_fields ||= Utils.clone fields
      end

      # A copy of {#fields} for show page
      # @return [ActiveSupport::HashWithIndifferentAccess] metadata
      def show_fields
        @show_fields ||= Utils.clone fields
      end

      # A copy of {#fields} for form (new/edit) page
      # @return [ActiveSupport::HashWithIndifferentAccess] metadata
      def form_fields
        @form_fields ||= Utils.clone fields
      end

      # @return [Array<String>] a list of field names for index page
      def index_field_names
        @index_field_names ||= reposition index_fields.keys, primary_key
      end

      # @return [Array<String>] a list of field names for show page
      def show_field_names
        @show_field_names ||= reposition show_fields.keys, primary_key
      end

      # @return [Array<String>] a list of field names for form (new/edit) page
      def form_field_names
        @form_field_names ||= form_fields.keys - [primary_key.to_s]
      end

      # @return [ActiveModel::Errors]
      def form_active_errors(resource)
        @form_active_errors ||= ActiveModel::Errors.new resource
      end

      # @return [String, Symbole] primary key name
      def primary_key
        @primary_key ||= :id
      end

      # @param resource [Object]
      # @return [String]
      def guess_title(resource)
        field_name = FieldUtils.first_field_by({ name: /name|title|subject/ }, fields)
        ModuleUtils.try_to resource, field_name
      end
    end
  end
end
