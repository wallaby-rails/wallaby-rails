module Wallaby
  # Hash utils
  module HashUtils
    class << self
      # Slice and permit values
      # @param hash_or_parameters [ActionController::Parameters, Hash]
      # @param keys [Array<String, Symbol>]
      # @return [String] output
      def slice!(hash_or_parameters, *keys)
        normalized = hash_or_parameters.is_a?(Hash) ? hash_or_parameters.with_indifferent_access : hash_or_parameters
        sliced = normalized.slice(*keys)
        ModuleUtils.try_to(sliced, :permit!) || sliced
      end
    end
  end
end
