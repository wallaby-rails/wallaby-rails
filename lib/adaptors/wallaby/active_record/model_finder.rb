module Wallaby
  class ActiveRecord
    # Model finder
    class ModelFinder < Wallaby::ModelFinder
      def base
        Rails.cache.fetch 'wallaby/active_record/model_finder/base' do
          if defined? ::ApplicationRecord
            ::ApplicationRecord
          else
            ::ActiveRecord::Base
          end
        end
      end

      def all
        Rails.cache.fetch 'wallaby/active_record/model_finder' do
          base.subclasses.reject do |model_class|
            model_class.abstract_class? ||
              model_class.to_s.start_with?('#<') ||
              model_class.name == 'ActiveRecord::SchemaMigration' ||
              model_class.name.index('HABTM')
          end.sort_by(&:to_s)
        end
      end
    end
  end
end
