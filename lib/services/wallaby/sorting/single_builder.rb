module Wallaby
  module Sorting
    # Generate sort param for only one field's next sort order
    # (e.g. from empty to `asc`, from `asc` to `desc`, from `desc` to empty)
    class SingleBuilder < NextBuilder
      protected

      # @param field_name [String] field name
      # @return [String] a sort order string, e.g. `'name asc'`
      def complete_sorting_str_with(field_name)
        hash = {}
        current_sort = @hash[field_name]
        hash[field_name] = next_value_for current_sort
        rebuild_str_from hash
      end
    end
  end
end
