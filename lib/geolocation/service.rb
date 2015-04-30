module Geolocation
  module Service
    extend self

    CACHE_SIZE = Settings.geolocation.default_cache_size

    def locate(ip)
      cached_result = cache[ip]
      
      if cached_result
        cached_result
      else
        result    = api_client.locate(ip)
        cache[ip] = result
        result
      end
    end

    def clear_cache!
      cache.clear!
    end

    def api_client
      @api_client ||= Geolocation::ApiClient
    end

    def cache
      @cache ||= Geolocation::Cache.new(CACHE_SIZE)
    end
  end
end