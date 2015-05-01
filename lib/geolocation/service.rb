require_relative '../cache'

module Geolocation
  module Service
    extend self

    CACHE_FILE          = File.join(File.dirname(__FILE__), '../../', Settings.geolocation.cache_file)
    CACHE_SIZE          = Settings.geolocation.cache_size
    CACHE_DUMP_INTERVAL = Settings.geolocation.cache_dump_interval

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

    def start!
      load_cache!
      
      Thread.new do 
        loop do
          sleep CACHE_DUMP_INTERVAL
          dump_cache
        end
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
        @cache = Cache.from_dumpfile(CACHE_FILE)
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
      @cache ||= Cache.new(CACHE_SIZE)
    end
  end
end