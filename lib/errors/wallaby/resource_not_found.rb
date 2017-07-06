module Wallaby
  # Resource not found error
  class ResourceNotFound < NotFound
    def message
      I18n.t 'errors.not_found.resource', resource: super
    end
  end
end
