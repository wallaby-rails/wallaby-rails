module Wallaby
  class ActiveRecord
    class ModelServiceProvider
      # @!visibility private
      # Query builder
      class Querier
        TEXT_FIELDS = %w(string text citext longtext tinytext mediumtext).freeze

        # @param model_decorator [Wallaby::ModelDecorator]
        def initialize(model_decorator)
          @model_decorator = model_decorator
          @model_class = @model_decorator.model_class
        end

        # Pull out the query expression string from the parameter `q`,
        # use parser to understand the expression, then use transformer to run
        # SQL arel query.
        # @param params [ActionController::Parameters]
        # @return [ActiveRecord::Relation]
        def search(params)
          filter_name, keywords, field_queries = extract params
          scope = filtered_by filter_name
          query = text_search keywords
          query = field_search field_queries, query
          scope.where query
        end

        private

        # @see Wallaby::Parser
        def parser
          @parser ||= Parser.new
        end

        # @see Wallaby::ActiveRecord::ModelServiceProvider::Querier::Transformer
        def transformer
          @transformer ||= Transformer.new
        end

        # @return [Arel::Table] arel table
        def table
          @model_class.arel_table
        end

        # @param params [ActionController::Parameters]
        # @return [Array<String, Array, Array>] a list of object for other
        #   method to use.
        def extract(params)
          expressions = to_expressions params
          keywords = expressions.select { |v| v.is_a? String }
          field_queries = expressions.select { |v| v.is_a? Hash }
          filter_name = params[:filter]
          [filter_name, keywords, field_queries]
        end

        # @param params [ActionController::Parameters]
        # @return [Array] a list of transformed operations
        def to_expressions(params)
          parsed = parser.parse(params[:q] || EMPTY_STRING)
          converted = transformer.apply parsed
          converted.is_a?(Array) ? converted : [converted]
        end

        # Use the filter name to find out the scope in the following precedents:
        # - scope from metadata
        # - defined scope from the model
        # - unscoped
        # @param filter_name [String] filter name
        # @return [ActiveRecord::Relation]
        def filtered_by(filter_name)
          valid_filter_name =
            Utils.find_filter_name(filter_name, @model_decorator.filters)
          scope = find_scope(valid_filter_name)
          if scope.blank? then unscoped
          elsif scope.is_a?(Proc) then @model_class.instance_exec(&scope)
          elsif @model_class.respond_to?(scope)
            @model_class.public_send(scope)
          else unscoped
          end
        end

        # Find out the scope for given filter
        # - from metadata
        # - filter name itself
        # @param filter_name [String] filter name
        # @return [String]
        def find_scope(filter_name)
          filter = @model_decorator.filters[filter_name].to_h
          filter[:scope] || filter_name
        end

        # Unscoped query
        # @return [ActiveRecord::Relation]
        def unscoped
          @model_class.where nil
        end

        # Search text for the text columns that appear in `index_field_names`
        # @param keywords [String] keywords
        # @param query [ActiveRecord::Relation, nil]
        # @return [ActiveRecord::Relation]
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

        # Perform SQL query for the colon query (e.g. data:<2000-01-01)
        # @param field_queries [Array]
        # @param query [ActiveRecord::Relation]
        # @return [ActiveRecord::Relation]
        def field_search(field_queries, query)
          return query unless field_check? field_queries
          field_queries.each do |exp|
            sub_query = table[exp[:left]].public_send(exp[:op], exp[:right])
            query = query.try(:and, sub_query) || sub_query
          end
          query
        end

        # @return [Array<String>] a list of text fields from `index_field_names`
        def text_fields
          @text_fields ||= begin
            index_field_names = @model_decorator.index_field_names.map(&:to_s)
            @model_decorator.fields.select do |field_name, metadata|
              index_field_names.include?(field_name) &&
                TEXT_FIELDS.include?(metadata[:type].to_s)
            end.keys
          end
        end

        # @param keywords [Array<String>] a list of keywords
        # @return [Boolean] false when keywords are empty
        #   true when text fields for query exist
        #   otherwise, raise exception
        def keywords_check?(keywords)
          return false if keywords.blank?
          return true if text_fields.present?
          message = I18n.t 'errors.unprocessable_entity.keyword_search'
          raise UnprocessableEntity, message
        end

        # @param field_queries [Array]
        # @return [Boolean] false when field queries are blank
        #   true when the fields used are valid (exist in `fields`)
        #   otherwise, raise exception
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
