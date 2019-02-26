module Wallaby
  module Sorting
    # Build link for sorting
    class LinkBuilder
      delegate :model_class, to: :@model_decorator

      # @param model_decorator [Wallaby::ModelDecorator]
      # @param params [ActionController::Parameters]
      # @param helper [ActionView::Helpers]
      def initialize(model_decorator, params, helper)
        @model_decorator = model_decorator
        @params = params
        @helper = helper
      end

      # To return the sort hash converted from string value, e.g. `{ 'title' => 'asc', 'updated_at' => 'desc' }`
      # converted from `'title asc, updated_at desc'`
      # @return [Hash] current sort hash
      def current_sort
        @current_sort ||= HashBuilder.build @params[:sort]
      end

      # Build sort link for given field name:
      #
      # ```
      # <a title="Product" href="/admin/products?sort=published_at+asc">Name</a>
      # ```
      #
      # If the field is not sortable, it returns a text, e.g.:
      #
      # ```
      # Name
      # ```
      # @param field_name [String]
      # @return [String] link or text
      def build(field_name)
        metadata = @model_decorator.index_metadata_of field_name
        label = to_field_label field_name, metadata
        return label unless sortable? field_name, metadata
        sort_field_name = metadata[:sort_field_name] || field_name
        url_params = next_builder.next_params sort_field_name
        @helper.index_link(model_class, url_params: url_params) { label }
      end

      private

      # @return [Wallaby::Sorting::NextBuilder]
      def next_builder
        @next_builder ||= NextBuilder.new @params, current_sort
      end

      # @return [Boolean] true if sortable
      def sortable?(field_name, metadata)
        !metadata[:sort_disabled] && (@model_decorator.fields[field_name] || metadata[:sort_field_name])
      end

      def to_field_label(field_name, metadata)
        metadata[:label] || field_name.to_s.humanize
      end
    end
  end
end
