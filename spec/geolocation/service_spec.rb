require 'spec_helper'

describe Geolocation::Service do
  let(:location)   { double IPLocation      }
  let(:ip)         { '184.75.209.18'        }
  let(:service)    { Geolocation::Service   }

  before(:each) do
    allow(service).to receive(:dump_cache)
    service.clear_cache!
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
end