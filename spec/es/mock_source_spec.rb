require 'spec_helper'

describe ES::MockSource do
  let(:src)       { ES::MockSource.from_settings  } 
  let(:settings)  { Settings.mock_api             }

  context 'Setup' do
    it 'should initialize the mock api from the settings file' do
      expect(ES::MockSource).to receive(:new).with(
        settings.host,
        settings.port,
      )

      ES::MockSource.from_settings
    end

    it 'can handle mock API errors' do
      allow_any_instance_of(Net::HTTP).to receive(:request).and_raise(Errno::ECONNREFUSED)

      expect { src.retrieve_all }.to raise_error(ES::MockSource::MockAPIFailure)
    end
  end

  context 'Methods' do
    it '#available? - check if the API is available' do
      expect(src.available?).to be true

      allow_any_instance_of(Net::HTTP).to receive(:request).and_raise(Errno::ECONNREFUSED)
      expect(src.available?).to be false
    end

    it '#retrieve_all - retrieve all fields query' do
      data    = src.retrieve_all
      records = LogData::Record.from_es_data(data)

      expect(records.count).to be ES::MockRecordBuilder::DEFAULT_SIZE
      expect(records.all? { |record|
        record.is_a?(LogData::Record) && 
        record.fields['ip'] =~ /\b(?:\d{1,3}\.){3}\d{1,3}\b/
      })
    end

    it '#retrieve_fields - retrieve only specific fields in a query' do
      data    = src.retrieve_fields([:ip])
      fields  = data['hits']['hits'].first['_source']
      
      expect(fields['@timestamp']).not_to be nil
      expect(fields['@fields']['ip']).to match /\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b/
      expect(fields['@fields']['duration']).to be nil
    end
  end
end