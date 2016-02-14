if Rails.env.development?
  module ActionDispatch
    class Reloader
      to_prepare do
        Rails.logger.debug '-> Rails reloading, prepare to clear rails entire cache.'
        Rails.cache.clear
      end
    end
  end
end
