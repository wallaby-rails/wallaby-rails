module Wallaby
  class Custom
    # Custom modal decorator
    class ModelDecorator < ::Wallaby::ModelDecorator
      def fields
        @fields ||= ::ActiveSupport::HashWithIndifferentAccess.new.tap do |hash|
          methods = model_class.public_instance_methods(false).map(&:to_s)
          methods
            .grep(/[^=]$/)
            .select { |method_id| methods.include? "#{method_id}=" }
            .each { |attribute| hash[attribute] = { label: attribute.humanize, type: 'string' } }
        end
      end

      # A copy of `fields` for index page
      # @return [Hash] metadata
      def index_fields
        @index_fields ||= Utils.clone fields
      end

      # A copy of `fields` for show page
      # @return [Hash] metadata
      def show_fields
        @show_fields  ||= Utils.clone fields
      end

      # A copy of `fields` for form (new/edit) page
      # @return [Hash] metadata
      def form_fields
        @form_fields  ||= Utils.clone fields
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
        @form_field_names ||= form_fields.keys.without primary_key.to_s
      end

      # @raise [Wallaby::NotImplemented]
      def form_active_errors(resource)
        @form_active_errors ||= ActiveModel::Errors.new resource
      end

      # @raise [Wallaby::NotImplemented]
      def primary_key
        @primary_key ||= :id
      end

      # @raise [Wallaby::NotImplemented]
      def guess_title(resource)
        resource.inspect
      end
    end
  end
end
