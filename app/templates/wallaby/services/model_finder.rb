module Wallaby
  module Services
    class ModelFinder
      def find model_name
        model_regexp = %r(\A#{ normalize(model_name) }\Z)i
        available_models.find do |model_class|
          model_class.to_s.match model_regexp
        end
      end

      def available_models
        if only_models.present?
          all.collect do |model|
            only_models.include? model.name
          end
        elsif except_models.present?
          all.collect do |model|
            !except_models.include? model.name
          end
        else
          all
        end
      end

      def all
        raise Wallaby::NotImplemented
      end

      def normalize model_name
        model_name.singularize.camelize
      end

      protected
      def only_models
        Wallaby.configuration.models.only.map &:to_s
      end

      def except_models
        Wallaby.configuration.models.except.map &:to_s
      end
    end
  end
end