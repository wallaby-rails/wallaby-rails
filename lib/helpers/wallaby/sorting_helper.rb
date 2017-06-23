module Wallaby
  # Sort helper
  module SortingHelper
    def sort_link(field_name, model_decorator = current_model_decorator)
      metadata = model_decorator.index_metadata_of field_name
      return metadata[:label] unless sortable? metadata
      sort_field_name = metadata[:sort_field_name] || field_name
      extra_params = next_sort_param sort_field_name
      model_class = model_decorator.model_class
      index_link(model_class, extra_params: extra_params) { metadata[:label] }
    end

    def sort_class(field_name)
      current_sort[field_name]
    end

    protected

    def current_sort
      @current_sort ||= Sorting::HashBuilder.build params[:sort]
    end

    def next_sort_param(field_name)
      @next_builder ||= Sorting::NextBuilder.new index_params, current_sort
      @next_builder.next_params field_name
    end

    def sortable?(metadata)
      metadata[:is_origin] && !metadata[:is_association] \
        || metadata[:sort_field_name]
    end
  end
end
