class Wallaby::ActiveRecord::ModelFinder < Wallaby::ModelFinder
  protected
  def all
    Rails.cache.fetch 'wallaby/model_finder' do
      ActiveRecord::Base.subclasses.reject do |model_class|
        model_class.abstract_class? ||
        model_class.to_s.start_with?('#<') ||
        model_class.name == 'ActiveRecord::SchemaMigration' ||
        model_class.name.index('HABTM')
      end.sort_by &:to_s
    end
  end
end
