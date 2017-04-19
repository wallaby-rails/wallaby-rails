module Wallaby
  class ActiveRecord
    class ModelOperator
      # Query builder
      class Querier
        def initialize(model_decorator)
          @model_decorator  = model_decorator
          @model_class      = @model_decorator.model_class
        end

        def search(params)
          text_keywords, field_keywords = extract params
          query = @model_class.where nil
          query = text_search text_keywords, query
          query = field_search field_keywords, query
          query
        end

        protected

        def extract(params)
          all_keywords = (params[:q] || '').split(' ').compact
          field_keywords = all_keywords.select { |v| v.split(':').length == 2 }
          [all_keywords - field_keywords, field_keywords]
        end

        # TODO: use arel
        def text_search(keywords, query)
          return query if keywords.blank?
          queries = text_fields.inject([]) do |q, field_name|
            likes = keywords.map do |keyword|
              ["UPPER(#{field_name}) LIKE ?", "%#{keyword.upcase}%"]
            end
            q << ["(#{likes.map(&:first).join ' AND '})", likes.map(&:last)]
          end
          query.where \
            queries.map(&:first).join(' OR '),
            *queries.map(&:last).flatten
        end

        def field_search(keywords, query)
          return query if keywords.blank?
          hashed_queries =
            Wallaby::Utils.to_hash(keywords.map { |v| v.split ':' })
          query.where hashed_queries
        end

        def text_fields
          @model_decorator.fields.select do |field_name, metadata|
            @model_decorator.index_field_names.include?(field_name) &&
              %w[string text citext].include?(metadata[:type])
          end.keys
        end
      end
    end
  end
end
