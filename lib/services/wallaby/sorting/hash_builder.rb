module Wallaby
  module Sorting
    # Turn a string e.g.`'name asc,id desc'` into sort hash e.g.`{name: 'asc', id: 'desc'}`
    class HashBuilder
      SORT_REGEX = /(([^\s,]+)\s+(asc|desc))\s*,?\s*/i.freeze

      # Turn a string e.g.`'name asc,id desc'` into sort hash e.g.`{name: 'asc', id: 'desc'}`
      # @param sort_string [String]
      # @return [Hash] { field_name => 'asc|desc' }
      def self.build(sort_string)
        ::ActiveSupport::HashWithIndifferentAccess.new.tap do |hash|
          (sort_string || EMPTY_STRING).scan(SORT_REGEX) { |_, key, order| hash[key] = order }
        end
      end
    end
  end
end
