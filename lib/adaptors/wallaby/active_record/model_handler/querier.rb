module Wallaby
  class ActiveRecord
    class ModelHandler
      # Query builder
      class Querier
        def initialize(model_decorator)
          @model_decorator  = model_decorator
          @model_class      = @model_decorator.model_class
        end

        def search(params)
          text_keywords, field_keywords = extract params
          query = text_search text_keywords
          query = field_search field_keywords, query
          @model_class.where(query)
        end

        protected

        def table
          @model_class.arel_table
        end

        def extract(params)
          all_keywords = (params[:q] || EMPTY_STRING).split(SPACE).compact
          field_keywords = all_keywords.select { |v| v.split(':').length == 2 }
          [all_keywords - field_keywords, field_keywords]
        end

        def text_search(keywords, query = nil)
          return if keywords.blank?
          text_fields.each_with_object(query) do |query, field_name|
            sub_query = nil
            keywords.each do |keyword|
              q = table[field_name].matches("%#{keyword}%")
              sub_query = sub_query.try(:or, q) || q
            end
            query = query.try(:and, sub_query) || sub_query
          end
        end

        def field_search(colon_queries, query)
          return query if colon_queries.blank?
          colon_queries.each
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
