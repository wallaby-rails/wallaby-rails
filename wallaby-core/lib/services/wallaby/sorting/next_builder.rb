# frozen_string_literal: true

module Wallaby
  module Sorting
    # Generate sort param for given field's next sort order
    # (e.g. from empty to `asc`, from `asc` to `desc`, from `desc` to empty)
    class NextBuilder
      ASC = 'asc'
      DESC = 'desc'

      # @param params [ActionController::Parameters]
      # @param hash [Hash, nil] a hash containing sorting info, e.g. `{ name: 'asc' }`
      def initialize(params, hash = nil)
        @params = params
        @hash = hash.try(:with_indifferent_access) || HashBuilder.build(params[:sort])
      end

      # Update the `sort` parameter.
      # @example for param `{sort: 'name asc'}`, it updates the parameters to:
      #   {sort: 'name desc'}
      # @param field_name [String] field name
      # @return [ActionController::Parameters]
      #   updated parameters with new sort order for given field
      def next_params(field_name)
        params = Utils.clone @params
        params[:sort] = complete_sorting_str_with field_name
        params
      end

      protected

      # @param field_name [String] field name
      # @return [String] a sort order string, e.g. `'name asc'`
      def complete_sorting_str_with(field_name)
        hash = @hash.except field_name
        current_sort = @hash[field_name]
        hash[field_name] = next_value_for current_sort
        HashBuilder.to_str(hash)
      end

      # @param current [String, nil] current sort order
      # @return [String, nil] next sort order
      def next_value_for(current)
        case current
        when ASC then DESC
        when DESC then nil
        else ASC
        end
      end
    end
  end
end
