module Wallaby
  # Model not found error
  class ModelNotFound < NotFound
    # @return [String] not found error message
    def message
      I18n.t 'errors.not_found.model', model: super
    end
  end
end
