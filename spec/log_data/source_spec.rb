require 'spec_helper'

describe LogData::Source do
  let(:source)    { LogData::Source.from_settings  }
  let(:settings)  { Settings.elasticsearch_client  }

  context 'Setup' do
    it 'should create an instance of the Elasticsearch client' do
      expect(source.client).to be_an_instance_of Elasticsearch::Transport::Client
    end

    it 'should initialize the client from the settings file and env variables' do
      expect(LogData::Source).to receive(:new).with(
        settings['host'],
        settings['port'],
      )

      LogData::Source.from_settings
    end

    it 'it can handle API errors' do
      allow(source.client).to receive(:perform_request).and_raise(SocketError)

      expect { source.retrieve_all }.to raise_error(LogData::Source::ElasticsearchClientError)
    end
  end

  context 'Methods' do
    it '#available? - check if the API is available' do
      expect(source.available?).to be true 

      allow(source.client).to receive(:perform_request).and_raise(Errno::ECONNREFUSED)
      expect(source.available?).to be false
    end

    it '#retrieve_all - retrieve all fields query' do
      data = source.retrieve_all

      expect(data['timed_out']).to be false
      expect(data['hits']['total']).to be > 0
    end

    it '#retrieve_fields - retrieve only specific fields in a query' do
      data    = source.retrieve_fields([:ip])
      fields  = data['hits']['hits'].first['_source']
      
      expect(fields['@timestamp']).not_to be nil
      expect(fields['@fields']['ip']).to match /\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b/
    end
  end
end