module Wallaby
  class ActiveRecord
    class ModelHandler
      # Query builder
      class Querier
        def initialize(model_decorator)
          @model_decorator = model_decorator
          @model_class = @model_decorator.model_class
        end

        def search(params)
          keywords, field_queries = extract params
          query = text_search keywords
          query = field_search field_queries, query
          @model_class.where query
        end

        private

        def parser
          @parser ||= Parser.new
        end

        def transformer
          @transformer ||= Transformer.new
        end

        def table
          @model_class.arel_table
        end

        def extract(params)
          parsed = parser.parse(params[:q] || EMPTY_STRING)
          converted = transformer.apply parsed
          expressions = converted.is_a?(Array) ? converted : [converted]
          keywords = expressions.select { |v| v.is_a? String }
          field_queries = expressions.select { |v| v.is_a? Hash }
          [keywords, field_queries]
        end

        def text_search(keywords, query = nil)
          return if keywords.blank?
          text_fields.each do |field_name|
            sub_query = nil
            keywords.each do |keyword|
              exp = table[field_name].matches("%#{keyword}%")
              sub_query = sub_query.try(:and, exp) || exp
            end
            query = query.try(:or, sub_query) || sub_query
          end
          query
        end

        def field_search(field_queries, query)
          return query if field_queries.blank?
          field_queries.each do |exp|
            next unless @model_decorator.fields[exp[:left]]
            exp = table[exp[:left]].public_send(exp[:op], exp[:right])
            query = query.try(:and, exp) || exp
          end
          query
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
