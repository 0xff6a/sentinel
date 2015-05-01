require 'spec_helper'

describe Geolocation::ApiClient do 
  let(:ip)      { '81.134.202.29'        }
  let(:ip2)     { '83.134.210.29'        }
  let(:client)  { Geolocation::ApiClient }

  context '#locate' do
    it 'returns a lat/long coordinate pair for a given IP' do
      location = client.locate(ip)

      expect(location.ip).to eq '81.134.202.29'
      expect(location.country).to eq 'TT'
      expect(location.lat).to be_within(90).of(0)
      expect(location.lng).to be_within(180).of(0)
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