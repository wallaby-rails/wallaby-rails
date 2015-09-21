class Wallaby::ActiveRecord::ModelFinder < Wallaby::ModelFinder
  protected
  def all
    ActiveRecord::Base.subclasses.reject do |model_class|
      model_class.abstract_class? || [  ].include?(model_class)
    end
  end
end