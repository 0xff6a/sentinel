require 'spec_helper'

describe Analyzer::Geographical do
  let(:source)  { JSON.parse(File.read('resources/response.json'))  }
  let(:records) { LogData::Record.from_source(source)               }

  context '#activity_by_ip' do
    it 'should return a count of access by country code given a list of records' do
      result = Analyzer::Geographical.activity_by_ip(records)

      expect(result).to eq({ 
        "199.87.228.66" => 1,
        "62.25.109.201" => 1,
        "85.17.156.11"  => 2
      })
    end
  end

  context 'AccessCount' do
    let(:ip)          { '1.2.3.4'         }
    let(:ip_location) { double IPLocation }

    it 'is initialized with an ip_location and a count' do
      data_point = Analyzer::Geographical::AccessCount.new(ip_location, 2) 

      expect(data_point.ip_location).to eq ip_location
      expect(data_point.count).to eq 2
    end

    it 'can be built from an ip and a count' do
      allow(Tools::Geolocator).to receive(:locate).with(ip).and_return(ip_location)
      data_point = Analyzer::Geographical::AccessCount.build_from(ip, 2)

      expect(data_point.ip_location).to eq ip_location
      expect(data_point.count).to eq 2
    end
  end
end