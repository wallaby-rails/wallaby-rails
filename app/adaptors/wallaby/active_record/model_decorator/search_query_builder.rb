class Wallaby::ActiveRecord::ModelDecorator::SearchQueryBuilder
  def initialize(model_class, fields)
    @model_class  = model_class
    @fields       = fields
  end

  def build(keyword)
    query = @model_class.where(nil)
    return query unless keyword.present?
    queries = search_queries keyword
    query.where queries.keys.join(' OR '), *queries.values
  end

  protected
  def search_queries(keyword, fields = @fields)
    queries = {}
    fields.each do |field_name, metadata|
      case metadata[:type]
      when 'integer', 'float'
        queries["#{ field_name } = ?"] = keyword if %r(^\d+(\.\d+)?$) =~ keyword
      when 'boolean'
        queries["#{ field_name } = ?"] = keyword if %r(^(true|false)$) =~ keyword
      when 'date', 'datetime', 'time'
        if date = Time.zone.parse(keyword) rescue nil
          queries["#{ field_name } = ?"] = date
        end
      when 'string', 'text'
        like_keyword = "%#{ keyword }%".upcase
        queries["UPPER(#{ field_name }) LIKE ?"] = like_keyword
      end
    end
    queries
  end
end