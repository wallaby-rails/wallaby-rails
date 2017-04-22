module Wallaby
  # Sort helper
  module SortingHelper
    def sort_link(field_name, model_decorator = current_model_decorator)
      metadata = model_decorator.index_metadata_of field_name
      return metadata[:label] unless sortable?(metadata)
      sort_field_name = metadata[:sort_field_name] || field_name
      extra_params = next_sort_param(sort_field_name).permit!.to_h
      model_class = model_decorator.model_class
      index_link(model_class, extra_params: extra_params) { metadata[:label] }
    end

    def sort_hash
      @sort_hash ||= begin
        array =
          params[:sort].to_s.split(/\s*,\s*/).map { |v| v.split(/\s+/) }
        Wallaby::Utils.to_hash array
      end
    end

    def next_sort_param(field_name)
      field_name  = field_name.to_s
      orders      = ['asc', 'desc', nil]
      clean_params.tap do |hash|
        sortings = sort_hash.dup
        next_index = (orders.index(sortings[field_name]) + 1) % orders.length
        restruct_sortings(sortings, orders, field_name, next_index)
        build_sort(hash, sortings)
      end
    end

    def sort_class(field_name)
      sort_hash[field_name.to_s]
    end

    protected

    def restruct_sortings(sortings, orders, field_name, next_index)
      if orders[next_index].nil?
        sortings.delete field_name
      else
        sortings[field_name] = orders[next_index]
      end
    end

    def build_sort(hash, sortings)
      if sortings.present?
        hash[:sort] = sortings.to_a.map { |v| v.join SPACE }.join COMMA
      else
        hash.delete :sort
      end
    end

    def sortable?(metadata)
      metadata[:is_origin] && !metadata[:is_association] \
        || metadata[:sort_field_name]
    end
  end
end
