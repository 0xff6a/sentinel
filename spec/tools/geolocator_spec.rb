require 'spec_helper'

describe Tools::Geolocator do 
  let(:ip)  { '81.134.202.29' }
  let(:ip2) { '83.134.210.29' }

  context '#locate' do
    it 'returns a lat/long coordinate pair for a given IP' do
      location = Tools::Geolocator.locate(ip)

      expect(location.ip).to eq '81.134.202.29'
      expect(location.country).to eq 'GB'
      expect(location.lat).to eq 51.5
      expect(location.lng).to eq -0.13
    end
  end

  context '#bulk_locate' do
    it 'can query multiple IPs' do
      locations = Tools::Geolocator.bulk_locate([ip, ip2])

      expect(locations[0].lat).to eq 51.5
      expect(locations[1].lat).to eq 50.467
    end
  end

  context 'Handling API errors' do
    it 'can handle API response errors' do
      res = double Net::HTTPResponse, code: '500'
      allow_any_instance_of(Net::HTTP).to receive(:request).and_return(res)

      expect { Tools::Geolocator.locate(ip) }
        .to raise_error(Tools::Geolocator::GeolocationAPIError )
    end

    it 'can handle data limit exceeded errors' do
      res = double Net::HTTPResponse, code: '403'
      allow_any_instance_of(Net::HTTP).to receive(:request).and_return(res)

      expect { Tools::Geolocator.locate(ip) }
        .to raise_error(Tools::Geolocator::GeolocationDataLimitExceeded )
    end
  end
end