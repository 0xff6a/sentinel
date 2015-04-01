require 'spec_helper'

describe LogData::Source do
  let(:source)    { LogData::Source.from_settings                        }
  let(:settings)  { YAML::load_file(Settings::FILEPATH)['elasticsearch'] }

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
end