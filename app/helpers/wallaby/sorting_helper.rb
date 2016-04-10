module Wallaby::SortingHelper
  def sort_param(param_key)
    key     = param_key.to_s
    orders  = [ 'asc', 'desc', nil ]
    {}.tap do |hash|
      sortings  = Hash[ *params[:sort].to_s.split(',').map{ |v| v.split ' ' }.flatten(1) ]
      nex_index = (orders.index(sortings[key]) + 1) % orders.length
      if orders[nex_index].nil?
        sortings.delete key
      else
        sortings[key] = orders[nex_index]
      end
      if sortings.present?
        hash[:sort] = sortings.to_a.map{ |v| v.join ' ' }.join ','
      end
    end
  end

  def sort_class(param_key)
    key = param_key.to_s
    sortings = Hash[ *params[:sort].to_s.split(',').map{ |v| v.split ' ' }.flatten(1) ]
    sortings[key]
  end
end
