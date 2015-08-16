module Wallaby
  class ActiveRecordModelFinder < ModelFinder
    protected
    def all
      ActiveRecord::Base.subclasses.reject do |model_class|
        model_class.abstract_class? || [ ActiveRecord::SchemaMigration ].include?(model_class)
      end
    end
  end
end