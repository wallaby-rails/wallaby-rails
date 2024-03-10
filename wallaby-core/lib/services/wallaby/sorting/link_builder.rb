# frozen_string_literal: true

module Wallaby
  module Sorting
    # Build link for sorting
    class LinkBuilder
      SORT_STRATEGIES = { single: SingleBuilder }.with_indifferent_access.freeze

      delegate :model_class, to: :@model_decorator
      delegate :index_link, :url_for, to: :@helper

      # @param model_decorator [ModelDecorator]
      # @param params [ActionController::Parameters]
      # @param helper [ActionView::Helpers]
      def initialize(model_decorator, params, helper, strategy)
        @model_decorator = model_decorator
        @params = params
        @helper = helper
        @strategy = strategy
      end

      # To return the sort hash converted from string value, e.g. `{ 'title' => 'asc', 'updated_at' => 'desc' }`
      # converted from `'title asc, updated_at desc'`
      # @return [Hash] current sort hash
      def current_sort
        @current_sort ||= HashBuilder.build @params[:sort]
      end

      # Build sort link for given field name:
      #
      #     <a title="Product" href="/admin/products?sort=published_at+asc">Name</a>
      #
      # If the field is not sortable, it returns a text, e.g.:
      #
      #     Name
      # @param field_name [String]
      # @return [String] link or text
      def build(field_name)
        metadata = @model_decorator.index_metadata_of field_name
        label = @model_decorator.index_label_of field_name
        return label unless sortable? field_name, metadata

        sort_field_name = metadata[:sort_field_name] || field_name
        url_params = next_builder.next_params sort_field_name
        index_link(
          model_class, url_params: url_params.merge(with_query: true)
        ) { label }
      end

      private

      # @return [Sorting::NextBuilder]
      def next_builder
        @next_builder ||= begin
          klass = SORT_STRATEGIES[@strategy] || NextBuilder
          klass.new @params, current_sort
        end
      end

      # @return [Boolean] true if sortable or `sort_field_name` is provided in the metadata
      def sortable?(field_name, metadata)
        !metadata[:sort_disabled] && (@model_decorator.fields[field_name] || metadata[:sort_field_name])
      end
    end
  end
end
