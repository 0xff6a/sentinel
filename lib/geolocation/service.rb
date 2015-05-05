module Geolocation
  module Service
    extend CacheManager
    extend self

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

    def api_client
      @api_client ||= Geolocation::ApiClient
    end
  end
end