module Wallaby
  # Hash utils
  module ParamsUtils
    class << self
      def presence(params)
        params.delete_if { |_, v| v.nil? || v == '' }
      end
    end
  end
end
