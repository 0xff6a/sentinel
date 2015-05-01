module Geolocation
  module Service
    extend self

    CACHE_FILE = File.join(File.dirname(__FILE__), '../../', Settings.geolocation.cache_file)
    CACHE_SIZE = Settings.geolocation.cache_size

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
      self
    end

    def clear_dump!
      File.delete(CACHE_FILE) if File.exists?(CACHE_FILE)
      self
    end

    def load_cache!
      if File.exists?(CACHE_FILE)
        @cache = Geolocation::Cache.from_dumpfile(CACHE_FILE)
      else
        warn 'No cache dump file present!'
      end
      self
    end

    def dump_cache
      @cache.dump_to_file(CACHE_FILE)
      self
    end

    def api_client
      @api_client ||= Geolocation::ApiClient
    end

    def cache
      @cache ||= Geolocation::Cache.new(CACHE_SIZE)
    end
  end
end