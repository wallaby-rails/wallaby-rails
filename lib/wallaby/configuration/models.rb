class Wallaby::Configuration::Models
  def set(models)
    @models = Array models
  end

  def presence
    @models.presence
  end

  def excludes
    @excludes ||= []
  end

  def exclude(*models)
    @excludes = models
  end
end
