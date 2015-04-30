require 'spec_helper'

describe LogData::Record do
  let(:params)  { {"@fields"=>{"ip"=>"178.255.153.2"}, "@timestamp"=>"2015-03-22T06:24:41.530+00:00"} }
  let(:source)  { JSON.parse(File.read('resources/response.json'))                                    }
  let(:record)  { LogData::Record.new(params)                                                         }

  context 'Setup' do
    it 'is initialized with a hash of fields and a timestamp' do
      expect(record.timestamp).to eq "2015-03-22T06:24:41.530+00:00"
      expect(record.fields['ip']).to eq "178.255.153.2"
    end

    it 'multiple records can be created from a source client response' do
      records = LogData::Record.from_es_data(source)

      expect(records.count).to eq 4
      expect(
        records.all? { |r| r.is_a?(LogData::Record) }
      ).to be true
    end
  end
end