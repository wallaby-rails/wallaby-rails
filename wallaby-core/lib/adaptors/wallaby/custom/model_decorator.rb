# frozen_string_literal: true

module Wallaby
  class Custom
    # {Custom} mode decorator that only pulls out all the attributes from setter/getter pair methods.
    class ModelDecorator < ::Wallaby::ModelDecorator
      # Retrieve the attributes from the setter/getter pair methods, e.g. `name=` and `name`
      # @return [ActiveSupport::HashWithIndifferentAccess] metadata
      def fields
        @fields ||=
          ::ActiveSupport::HashWithIndifferentAccess.new.tap do |hash|
            methods = model_class.public_instance_methods(false).map(&:to_s)
            methods
              .grep(/[^=]$/).select { |method_id| methods.include? "#{method_id}=" }
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

      # It returns an ActiveModel::Errors instance. However, this instance does not contain any errors.
      # You might want to override this method in the custom resource decorator
      # and get the errors out from the given **resource**.
      # @param resource [Object]
      # @return [ActiveModel::Errors]
      def form_active_errors(resource)
        @form_active_errors ||= ActiveModel::Errors.new resource
      end

      # @return [String, Symbole] default to `:id`
      def primary_key
        @primary_key ||= :id
      end

      # @param resource [Object]
      # @return [String, nil]
      def guess_title(resource)
        FieldUtils
          .first_field_by({ name: /name|title|subject/ }, fields)
          .try { |field_name| resource.try field_name }
      end
    end
  end
end
