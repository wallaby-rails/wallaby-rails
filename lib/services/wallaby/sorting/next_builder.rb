module Wallaby
  module Sorting
    # Pass field_name to generate sort param
    class NextBuilder
      ASC = 'asc'.freeze
      DESC = 'desc'.freeze

      def initialize(params, hash = nil)
        @params = params
        @hash = hash || HashBuilder.build(params[:sort])
      end

      def next_params(field_name)
        params = clean_params
        update params, :sort, complete_sorting_str_with(field_name)
        params
      end

      protected

      def clean_params
        @params.except :resources, :controller, :action
      end

      def complete_sorting_str_with(field_name)
        hash = @hash.except field_name
        current_sort = @hash[field_name]

        update hash, field_name, next_value_for(current_sort)
        rebuild_str_from hash
      end

      def rebuild_str_from(hash)
        hash.each_with_object '' do |(name, sort), str|
          str << (str == EMPTY_STRING ? str : COMMA)
          str << name << SPACE << sort
        end
      end

      def next_value_for(current)
        case current
        when ASC then DESC
        when DESC then nil
        else ASC
        end
      end

      def update(hash, key, value)
        return hash.delete key if value.blank?
        hash[key] = value
      end
    end
  end
end
