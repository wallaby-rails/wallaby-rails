class Wallaby::ServicerFinder
  def self.find(model_class)
    cached_subclasses.find do |klass|
      klass.model_class == model_class
    end || Wallaby.adaptor.model_operator
  end

  protected
  def self.cached_subclasses
    Rails.cache.fetch 'wallaby/servicer_finder' do
      Wallaby::ModelServicer.subclasses.reject do |klass|
        klass.name.blank?
      end
    end
  end
end
