# frozen_string_literal: true

module Wallaby
  class ResourceNotFound < NotFound # :nodoc:
    # @return [String] resource not found error message
    def message
      Locale.t 'errors.not_found.resource', resource: super
    end
  end
end
