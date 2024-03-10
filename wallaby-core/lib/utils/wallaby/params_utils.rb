# frozen_string_literal: true

module Wallaby
  # Hash utils
  module ParamsUtils
    class << self
      # @param params [Array<Hash>]
      # @return [Hash] combined hash that removes empty values
      def presence(*params)
        params.reduce({}, :merge).delete_if { |_, v| v.nil? || v == '' }
      end
    end
  end
end
