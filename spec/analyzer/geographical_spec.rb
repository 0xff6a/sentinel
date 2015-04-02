require 'spec_helper'

describe Analyzer::Geographical do
  let(:source)  { JSON.parse(File.read('resources/response.json'))  }
  let(:records) { LogData::Record.from_source(source)               }

  context '#activity_by_country' do
    it 'should return a count of access by country code given a list of records' do
      result = Analyzer::Geographical.activity_by_country(records)

      expect(result).to eq({ 
        "GB" => 1,
        "NL" => 2,
        "US" => 1
      })
    end
  end
end