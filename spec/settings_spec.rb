require 'spec_helper'

describe Settings do
  context 'Elastic Search API' do
    it 'should contain the Elastic search port and host' do
      es_settings  = Settings.elasticsearch_client

      expect(es_settings.host).to eq 'http://54.72.179.212'
      expect(es_settings.port).to eq 9200
    end
  end

  context 'Mock API' do
    it 'should contain the mock api server port and host' do
      mock_settings  = Settings.mock_api

      expect(mock_settings.host).to eq 'http://localhost'
      expect(mock_settings.port).to eq 6666
    end
  end

  context 'Geolocation API' do
    it 'should contain the geolocation api server port and host' do
      mock_settings  = Settings.geolocation_api

      expect(mock_settings.host).to eq 'http://localhost/geolocation'
      expect(mock_settings.port).to eq 6666
    end
  end

  context 'Geolocation' do
    it 'should contain the default cache size' do
      expect(Settings.geolocation.cache_size).to eq 1000
    end

    it 'should containt the cache filepath' do
      expect(Settings.geolocation.cache_file).to eq '/tmp/ip_location_cache.yml'
    end
  end
end