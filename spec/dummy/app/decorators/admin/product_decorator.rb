class Admin::ProductDecorator < Wallaby::ResourceDecorator
  filters[:featured] = {
    scope: -> { where(featured: true) }
  }
end
