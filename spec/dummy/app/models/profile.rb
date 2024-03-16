# frozen_string_literal: true

class Profile
  attr_accessor :id, :first_name, :last, :email

  def initialize(hash = {})
    assign hash
  end

  def assign(hash)
    hash.each do |k, v|
      public_send :"#{k}=", v
    end
  end

  def eql?(other)
    self.class == other.class && id.to_s == other.id.to_s
  end

  alias_method :==, :eql?

  class << self
    def cache_store
      @cache_store ||= ActiveSupport::Cache.lookup_store(:memory_store)
    end

    def cache_key
      :profile_cache_key
    end

    def find
      cache_store.fetch cache_key
    end

    def save(resource)
      cache_store.write cache_key, resource
    end

    def destroy(_resource)
      cache_store.write cache_key, nil
    end
  end
end
