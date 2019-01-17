module Wallaby
  class IndexRenderer < Renderer
    def string(locals)
      value = locals[:value]
      return null unless value
      max = metadata[:max] || default_metadata.max
      value = value.to_s
      return value unless value.length > max
      concat content_tag(:span, value.truncate(max))
      concat itooltip(value)
    end

    def integer(locals)
      value = locals[:value]
      value.try(:to_i) || null
    end
  end
end
