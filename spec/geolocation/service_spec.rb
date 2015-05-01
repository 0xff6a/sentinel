require 'spec_helper'

describe Geolocation::Service do
  let(:location)   { double IPLocation                                                            }
  let(:ip)         { '184.75.209.18'                                                              }
  let(:service)    { Geolocation::Service                                                         }
  let(:cache_file) { File.join(File.dirname(__FILE__), '../../', Settings.geolocation.cache_file) }

  before(:each) do
    service.clear_cache!
  end

  after(:each) do
    service.clear_dump!
  end

  context 'Calculating IP locations' do
    it 'if the ip location is not cached it should retrieve it from API and cache the result' do
      expect(Geolocation::ApiClient).to receive(:locate).with(ip).and_return(location)
      result = service.locate(ip)

      expect(result).to eq location
      expect(service.cache[ip]).to eq location
    end

    it 'the ip location is cached it should not call the API and return the cached value' do
      service.cache.fill({ ip => location })

      expect(Geolocation::ApiClient).not_to receive(:locate)
      result = service.locate(ip)

      expect(result).to eq location
    end
  end

  context 'Cache management' do
    it '#dump_cache - dumps cache contents to a YAML file' do
      service.cache.fill({ ip => location })
      service.dump_cache

      file_data = File.read(cache_file)

      expect(file_data).to eq(
         "--- !ruby/object:Cache\n" +
         "max_size: 1000\n" +
         "data:\n" +
         "  184.75.209.18: !ruby/object:RSpec::Mocks::Double\n" +
         "    __expired: false\n" +
         "    name: !ruby/class 'IPLocation'\n"
      )
    end

    it '#load_cache! - loads ip location data from a YAML dump file' do
      service.cache.fill({ ip => 'a location' })
      service.dump_cache
      service.clear_cache!

      expect(service.cache.count).to eq 0
      
      service.load_cache!
      expect(service.cache.to_a).to eq([
        [ ip, 'a location' ]
      ])
    end

    it 'if the cache file is not present it warns and does not modify the cache' do
      service.cache.fill({ ip => 'some other location' })
      
      expect{ service.load_cache! }.to output("No cache dump file present!\n").to_stderr
      expect(service.cache.to_a).to eq([
        [ ip, 'some other location' ]
      ])
    end
  end
end