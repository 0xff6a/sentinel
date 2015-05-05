require 'spec_helper'

describe Geolocation::CacheManager do
  let(:location)   { double IPLocation                                                            }
  let(:ip)         { '184.75.209.18'                                                              }
  let(:manager)    { Geolocation::CacheManager                                                    }
  let(:cache_file) { File.join(File.dirname(__FILE__), '../../', Settings.geolocation.cache_file) }

  before(:each) do
    manager.clear_cache!
  end

  after(:each) do
    manager.clear_dump!
  end

  it '#dump_cache - dumps cache contents to a YAML file' do
    manager.cache.fill({ ip => location })
    manager.dump_cache

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
    manager.cache.fill({ ip => 'a location' })
    manager.dump_cache
    manager.clear_cache!

    expect(manager.cache.count).to eq 0
    
    manager.load_cache!
    expect(manager.cache.to_a).to eq([
      [ ip, 'a location' ]
    ])
  end

  it 'if the cache file is not present it warns and does not modify the cache' do
    manager.cache.fill({ ip => 'some other location' })
    
    expect{ manager.load_cache! }.to output("No cache dump file present!\n").to_stderr
    expect(manager.cache.to_a).to eq([
      [ ip, 'some other location' ]
    ])
  end
end