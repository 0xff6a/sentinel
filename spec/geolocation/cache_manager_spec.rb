require 'spec_helper'

describe Geolocation::CacheManager do
  let(:location)   { double IPLocation                     }
  let(:ip)         { '184.75.209.18'                       }
  let(:manager)    { Geolocation::CacheManager             }
  let(:cache_file) { Geolocation::CacheManager::CACHE_FILE }

  before(:each) do
    manager.clear_cache!
  end

  after(:each) do
    manager.clear_cache!
  end

  it '#dump_cache - dumps cache contents to a YAML file' do
    manager.cache.fill({ ip => location })
    
    file_data = 
       "--- !ruby/object:Cache\n" +
       "max_size: 1000\n" +
       "data:\n" +
       "  184.75.209.18: !ruby/object:RSpec::Mocks::Double\n" +
       "    __expired: false\n" +
       "    name: !ruby/class 'IPLocation'\n" +
       "observer_state: false\n"

    expect(File).to receive(:write).with(cache_file, file_data)
    manager.dump_cache
  end

  it '#load_cache! - loads ip location data from a YAML dump file' do
    allow(File).to receive(:exists?).with(cache_file).and_return true

    c = Cache.new(Geolocation::CacheManager::CACHE_SIZE)

    expect(Cache).to receive(:from_dumpfile).with(cache_file).and_return(c)
    manager.load_cache!

    expect(manager.cache).to eq c
  end

  it 'if the cache file is not present it warns and does not modify the cache' do
    allow(File).to receive(:exists?).with(cache_file).and_return false
    manager.cache.fill({ ip => 'some other location' })
    
    expect{ manager.load_cache! }.to output("No cache dump file present!\n").to_stderr
    expect(manager.cache.to_a).to eq([
      [ ip, 'some other location' ]
    ])
  end
end