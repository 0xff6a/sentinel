require 'spec_helper'

describe Geolocation::ApiClient do 
  let(:ip)      { '81.134.202.29'        }
  let(:ip2)     { '83.134.210.29'        }
  let(:client)  { Geolocation::ApiClient }

  context '#locate' do
    it 'returns a lat/long coordinate pair for a given IP' do
      location = client.locate(ip)

      expect(location.ip).to eq '81.134.202.29'
      expect(location.country).to eq 'GB'
      expect(location.lat).to eq 51.5
      expect(location.lng).to eq -0.13
    end
  end

  context 'Handling API errors' do
    it 'can handle API response errors' do
      res = double Net::HTTPResponse, code: '500'
      allow_any_instance_of(Net::HTTP).to receive(:request).and_return(res)

      expect { client.locate(ip) }
        .to raise_error(client::GeolocationAPIError )
    end

    it 'can handle data limit exceeded errors' do
      res = double Net::HTTPResponse, code: '403'
      allow_any_instance_of(Net::HTTP).to receive(:request).and_return(res)

      expect { client.locate(ip) }
        .to raise_error(client::GeolocationDataLimitExceeded )
    end
  end
end