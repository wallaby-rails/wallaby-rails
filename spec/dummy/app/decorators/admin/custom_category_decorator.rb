# frozen_string_literal: true

module Admin
  class CustomCategoryDecorator < Wallaby::ResourceDecorator
    self.model_class = Category
  end
end
