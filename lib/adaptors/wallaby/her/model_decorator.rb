module Wallaby
  class Her
    # Modal decorator for Her
    class ModelDecorator < ::Wallaby::ModelDecorator
      # Generally, in Her, attribute methods are generated with this suffix
      ATTRIBUTE_SUFFIX = '_will_change!'.freeze

      # Origin metadata directly coming from Her.
      #
      # It needs to be frozen so that we can keep the metadata integrity
      # @example sample fields:
      #   model_decorator.fields
      #   # =>
      #   {
      #     # general field
      #     id: { type: 'integer', label: 'Id' },
      #     # association field
      #     category: {
      #       'type' => 'belongs_to',
      #       'label' => 'Category',
      #       'is_association' => true
      #     }
      #   }
      # @return [ActiveSupport::HashWithIndifferentAccess] metadata
      def fields
        @fields ||= ::ActiveSupport::HashWithIndifferentAccess.new.tap do |hash|
          hash.merge! general_fields
          hash.merge! association_fields
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
        @index_field_names ||=
          index_fields.reject do |_field_name, metadata|
            metadata[:is_association]
          end.keys
      end

      # @return [Array<String>] a list of field names for form (new/edit) page
      def form_field_names
        @form_field_names ||=
          Utils.clone(index_field_names)
               .delete_if { |field_name| field_name == primary_key.to_s }
      end

      # @return [ActiveModel::Errors, Hash] errors for resource
      # @see https://www.rubydoc.info/gems/her/Her/Model/Attributes/ClassMethods#store_response_errors-instance_method
      #   Her::Model::Attributes.store_response_errors
      def form_active_errors(resource)
        resource.errors.presence \
          || resource.instance_variable_get(:@response_errors)
      end

      # @return [String] primary key for the resource
      def primary_key
        @primary_key ||= @model_class.primary_key
      end

      # To guess the title for resource.
      #
      # It will go through the fields and try to find out the one that looks
      # like a name or text to represent this resource. Otherwise, it will fall
      # back to primary key.
      # @param resource [Object]
      # @return [String] the title of given resource
      def guess_title(resource)
        ModuleUtils.try_to resource, possible_title_field
      end

      protected

      # @return [Hash] a hash containing metadata for general fields
      def general_fields
        @general_fields ||=
          her_attributes.each_with_object({}) do |attribute, fields|
            fields[attribute.to_sym] = {
              type: 'string'.freeze,
              label: @model_class.human_attribute_name(attribute)
            }
          end
      end

      # @return [Hash] a hash containing metadata for association fields
      def association_fields
        @association_fields ||=
          @model_class.associations.each_with_object({}) do |(type, arr), hash|
            arr.each do |assoc|
              hash[assoc[:name]] = {
                type: type.to_s.freeze,
                label: @model_class.human_attribute_name(assoc[:name]),
                is_association: true, sort_disabled: true
              }
            end
          end
      end

      # @return [String] a field name that can be used as title (fall back to {#primary_key}).
      def possible_title_field
        @possible_title_field ||= begin
          target_field = general_fields.keys.find do |field_name|
            TITLE_NAMES.any? { |v| field_name.to_s.index v }
          end
          target_field || primary_key
        end
      end

      # **Her::Model::Attributes.attributes** will produce seven methods for an
      # attribute to track dirty data like ActiveModel
      # @see https://www.rubydoc.info/gems/her/Her/Model/Attributes/ClassMethods#attributes-instance_method
      #   Her::Model::Attributes.attributes
      # @return [Array<String>] a list of fields captured from instance methods
      def her_attributes
        instance_methods = @model_class.instance_methods
        possible_attributes =
          instance_methods.grep(/#{ATTRIBUTE_SUFFIX}$/).map do |method_id|
            method_id.to_s[0...-ATTRIBUTE_SUFFIX.length]
          end
        attributes = possible_attributes.select do |attribute|
          instance_methods.grep(/^#{attribute}\=?$/).length == 2 \
            && attribute !~ /(index_|show_|form_)?fields/
        end
        attributes.unshift(primary_key)
      end
    end
  end
end
