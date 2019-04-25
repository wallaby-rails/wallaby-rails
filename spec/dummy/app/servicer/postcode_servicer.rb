class PostcodeServicer < Wallaby::ModelServicer
  def self.cache_store
    @cache_store ||= ActiveSupport::Cache.lookup_store(:memory_store)
  end

  def permit(params, action)
    params.fetch(:postcode, params).permit(model_decorator.form_field_names)
  end

  def collection(params)
    rows_from_cache
  end

  def paginate(query, params)
    query
  end

  def new(params)
    Postcode.new({})
  end

  def find(id, params)
    rows_from_cache.find { |postcode| postcode.id.to_s == id.to_s }
  end

  def create(resource, params)
    model_decorator.form_field_names.each do |attribute|
      resource.public_send "#{attribute}=", params[attribute]
    end
    resource.id = rows_from_cache.max_by(&:id).try(:id).try(:to_i) + 1
    self.class.cache_store.write postcode_cache_key, rows_from_cache << resource
  end

  def update(resource, params)
    model_decorator.form_field_names.each do |attribute|
      resource.public_send "#{attribute}=", params[attribute] if params.key? attribute
    end
    rows = rows_from_cache
    index = rows.index { |postcode| postcode.id.to_s == resource.id.to_s }
    rows[index] = resource
    self.class.cache_store.write postcode_cache_key, rows
  end

  def destroy(resource, params)
    self.class.cache_store.write postcode_cache_key, rows_from_cache.reject { |p| p.id.to_s == resource.id.to_s }
  end

  private

  def rows_from_cache
    self.class.cache_store.fetch postcode_cache_key do
      CSV.read(
        Rails.root.join('app/csv/postcodes.csv'),
        headers: true,
        header_converters: [->(h) { h.downcase }],
        converters: :all,
      ).map do |row|
        Postcode.new row.to_h
      end
    end
  end

  def postcode_cache_key
    'postcode'
  end
end
