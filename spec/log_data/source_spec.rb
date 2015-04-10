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
  end

  context 'Querying elasticsearch', exclude: (ENV['TEST_FRAMEWORK'] == 'travis')  do
    it 'can get a list of available indices' do
      expect(source.indices).to include(
        "logstash-2015.03.23", 
        "logstash-2015.03.24", 
        "logstash-2015.03.21", 
        "logstash-2015.03.22", 
        "logstash-2015.03.20"
      )
    end

    it 'can query elasticsearch using the default query' do
      data = source.retrieve_all

      expect(data['timed_out']).to be false
      expect(data['hits']['total']).to be > 0
    end

    it 'can retrieve only specific fields' do
      data    = source.retrieve_fields([:ip])
      fields  = data['hits']['hits'].first['_source']
      
      expect(fields['@timestamp']).not_to be nil
      expect(fields['@fields']['ip']).to match /\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b/
    end
  end
end