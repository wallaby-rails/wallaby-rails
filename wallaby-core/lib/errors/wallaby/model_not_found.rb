# frozen_string_literal: true

module Wallaby
  class ModelNotFound < NotFound # :nodoc:
    # @return [String] not found error message
    def message
      return super if super.include? "\n"

      Locale.t 'errors.not_found.model', model: super
    end
  end
end
