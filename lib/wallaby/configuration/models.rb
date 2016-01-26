class Wallaby::Configuration::Models
  def excludes
    @excludes ||= []
  end

  def exclude(*models)
    @excludes = models
  end
end
