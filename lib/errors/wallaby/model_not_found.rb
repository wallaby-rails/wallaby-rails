module Wallaby
  # Model not found error
  class ModelNotFound < NotFound
    def message
      I18n.t 'errors.not_found.model', model: super
    end
  end
end
