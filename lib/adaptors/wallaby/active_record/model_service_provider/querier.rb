module Wallaby
  class ActiveRecord
    class ModelServiceProvider
      # Query builder
      class Querier
        TEXT_FIELDS = %w(string text citext longtext tinytext mediumtext).freeze

        def initialize(model_decorator)
          @model_decorator = model_decorator
          @model_class = @model_decorator.model_class
        end

        def search(params)
          filter_name, keywords, field_queries = extract params
          scope = filtered_by filter_name
          query = text_search keywords
          query = field_search field_queries, query
          scope.where query
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
          expressions = to_expressions params
          keywords = expressions.select { |v| v.is_a? String }
          field_queries = expressions.select { |v| v.is_a? Hash }
          filter_name = params[:filter]
          [filter_name, keywords, field_queries]
        end

        def to_expressions(params)
          parsed = parser.parse(params[:q] || EMPTY_STRING)
          converted = transformer.apply parsed
          converted.is_a?(Array) ? converted : [converted]
        end

        def filtered_by(filter_name)
          valid_filter_name =
            Utils.find_filter_name(filter_name, @model_decorator.filters)
          scope = find_scope(valid_filter_name)
          if scope.blank? then unscoped
          elsif scope.respond_to?(:call) then @model_class.instance_exec(&scope)
          elsif @model_class.respond_to?(scope)
            @model_class.public_send(scope)
          else unscoped
          end
        end

        def find_scope(filter_name)
          filter = @model_decorator.filters[filter_name] || {}
          filter[:scope] || filter_name
        end

        def unscoped
          @model_class.where nil
        end

        def text_search(keywords, query = nil)
          return query unless keywords_check? keywords
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
          return query unless field_check? field_queries
          field_queries.each do |exp|
            sub_query = table[exp[:left]].public_send(exp[:op], exp[:right])
            query = query.try(:and, sub_query) || sub_query
          end
          query
        end

        def text_fields
          @text_fields ||= begin
            index_field_names = @model_decorator.index_field_names.map(&:to_s)
            @model_decorator.fields.select do |field_name, metadata|
              index_field_names.include?(field_name) &&
                TEXT_FIELDS.include?(metadata[:type].to_s)
            end.keys
          end
        end

        def keywords_check?(keywords)
          return false if keywords.blank?
          return true if text_fields.present?
          message = I18n.t 'errors.unprocessable_entity.keyword_search'
          raise UnprocessableEntity, message
        end

        def field_check?(field_queries)
          return false if field_queries.blank?
          fields = field_queries.map { |exp| exp[:left] }
          invalid_fields = fields - @model_decorator.fields.keys
          return true if invalid_fields.blank?
          message = I18n.t 'errors.unprocessable_entity.field_colon_search',
                           invalid_fields: invalid_fields.to_sentence
          raise UnprocessableEntity, message
        end
      end
    end
  end
end
