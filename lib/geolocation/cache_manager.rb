require_relative '../cache'

module Geolocation
  module CacheManager
    extend self

    CACHE_FILE          = File.join(File.dirname(__FILE__), '../../', Settings.geolocation.cache_file)
    CACHE_SIZE          = Settings.geolocation.cache_size
    CACHE_DUMP_INTERVAL = Settings.geolocation.cache_dump_interval

    def cache
      @cache ||= Cache.new(CACHE_SIZE)
    end

    def start!
      load_cache!
      cache.add_observer(self)
    end

    def update
      dump_cache if (Time.now - update_time) > CACHE_DUMP_INTERVAL 
      @update_time = Time.now
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

    private

    def update_time
      @update_time ||= Time.now
    end
  end
end