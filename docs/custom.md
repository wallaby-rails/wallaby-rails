# Custom mode

It is possible to support non-ActiveModel resources in Wallaby.

For example, given the following model that reads CSV file and caches records in memory (TL;DR, [go straight to customization](#customization)):

```ruby
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
      resource.id = all.max_by(&:id).try(:id).try(:to_i) + 1
      cache_store.write cache_key, all << resource
    end

    def update(resource)
      all.tap do |rows|
        index = rows.index resource
        rows[index] = resource
        cache_store.write cache_key, rows
      end
    end

    def destroy(resource)
      cache_store.write cache_key, all.reject { |p| p.id == resource.id }
    end
  end
end
```

## Customization

To support it, the following minimum steps will be required:

- Add `Postcode` to the list of custom models in Wallaby initializer:

  ```ruby
  # config/initializers/wallaby.rb
  Wallaby.config do |config|
    config.custom_models = [Postcode]
  end
  ```

- Create a servicer `PostcodeServicer` to implemented the interface methods used by Wallaby controller:

  ```ruby
  # app/servicers/admin/postcode_servicer.rb
  class Admin::PostcodeServicer < Admin::ApplicationServicer
    def permit(params, _action)
      params.fetch(:postcode, params).permit(
        :postcode, :locality, :state, :long, :lat, :id, :dc, :type, :status
      )
    end

    def collection(_params)
      Postcode.all
    end

    def paginate(query, _params)
      query
    end

    def new(params)
      Postcode.new
    end

    def find(id, _params)
      Postcode.find id
    end

    def create(resource, params)
      resource.assign params
      Postcode.create resource
    end

    def update(resource, params)
      resource.assign params
      Postcode.update resource
    end

    def destroy(resource, _params)
      Postcode.destroy resource
    end
  end
  ```

  > NOTE: if the above interface methods aren't implemented, Wallaby will raise `Wallaby::NotImplemented` exception.

Then visit http://localhost:3000/admin/postcodes, and that's it!
