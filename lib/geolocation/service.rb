module Geolocation
  module Service
    extend self

    DEFAULT_CACHE_SIZE = 1000

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
      @cache ||= Geolocation::Cache.new(DEFAULT_CACHE_SIZE)
    end
  end
end