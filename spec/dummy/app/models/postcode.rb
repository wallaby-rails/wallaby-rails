class Postcode
  attr_accessor :postcode, :locality, :state, :long, :lat, :id, :dc, :type, :status

  def initialize(hash = {})
    assign hash
  end

  def assign(hash)
    hash.each do |k, v|
      public_send "#{k}=", v
    end
  end

  def eql?(other)
    self.class == other.class && id.to_s == other.id.to_s
  end

  alias == eql?

  class << self
    def cache_store
      @cache_store ||= ActiveSupport::Cache.lookup_store(:memory_store)
    end

    def cache_key
      :postcode_cache_key
    end

    def all
      # ...
      cache_store.fetch cache_key do
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

    def find(id)
      all.find { |postcode| postcode.id.to_s == id.to_s }
    end

    def create(resource)
      # ...
      resource.id = all.max_by(&:id).try(:id).try(:to_i) + 1
      cache_store.write cache_key, all << resource
    end

    def update(resource)
      # ...
      all.tap do |rows|
        index = rows.index resource
        rows[index] = resource
        cache_store.write cache_key, rows
      end
    end

    def destroy(resource)
      # ...
      cache_store.write cache_key, all.reject { |p| p.id == resource.id }
    end
  end
end
