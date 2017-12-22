module Wallaby
  module Sorting
    # Build the sorting link
    class LinkBuilder
      def initialize(model_decorator, params, helper)
        @model_decorator = model_decorator
        @params = params
        @helper = helper
      end

      # To turn sort string into a hash for later usage
      # @return [Hash]
      def current_sort
        @current_sort ||= HashBuilder.build @params[:sort]
      end

      # Build sort link for given field name
      # @param field_name [String]
      # @return [String] link
      def build(field_name)
        metadata = @model_decorator.index_metadata_of field_name
        label = Utils.to_field_label field_name, metadata
        return label unless sortable? metadata
        sort_field_name = metadata[:sort_field_name] || field_name
        url_params = next_builder.next_params sort_field_name
        @helper.index_link(model_class, url_params: url_params) { label }
      end

      private

      def model_class
        @model_class ||= @model_decorator.model_class
      end

      # @see Wallaby::Sorting::NextBuilder
      def next_builder
        @next_builder ||= NextBuilder.new @params, current_sort
      end

      # If it's non-association field or custom sorting field
      def sortable?(metadata)
        metadata[:is_origin] && !metadata[:is_association] \
          || metadata[:sort_field_name]
      end
    end
  end
end
