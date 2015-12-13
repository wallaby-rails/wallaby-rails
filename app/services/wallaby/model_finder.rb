class Wallaby::ModelFinder
  def available
    all_models = all
    (Wallaby.configuration.models.excludes || []).each do |model|
      all_models.delete model
    end
    all_models
  end

  protected
  def all
    raise Wallaby::NotImplemented
  end
end