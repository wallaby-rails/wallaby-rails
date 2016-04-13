module Wallaby::SortingHelper
  def sort_hash
    @sort_hash ||= begin
      array = params[:sort].to_s.split(%r(\s*,\s*)).map{ |v| v.split %r(\s+) }
      Wallaby::Utils.to_hash array
    end
  end

  def new_sort_param(field_name)
    field_name  = field_name.to_s
    orders      = [ 'asc', 'desc', nil ]
    params.dup.tap do |hash|
      sortings = sort_hash.dup
      next_index = (orders.index(sortings[field_name]) + 1) % orders.length
      if orders[next_index].nil?
        sortings.delete field_name
      else
        sortings[field_name] = orders[next_index]
      end
      if sortings.present?
        hash[:sort] = sortings.to_a.map{ |v| v.join ' ' }.join ','
      else
        hash.delete :sort
      end
    end
  end

  def sort_class(field_name)
    sort_hash[ field_name.to_s ]
  end
end
