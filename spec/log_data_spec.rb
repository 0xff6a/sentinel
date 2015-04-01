require 'spec_helper'

describe LogData::Source do
  let(:source)    { LogData::Source.from_settings                        }
  let(:settings)  { YAML::load_file(Settings::FILEPATH)['elasticsearch'] }

  it 'should create an instance of the Elasticsearch client' do
    expect(source.client).to be_an_instance_of Elasticsearch::Transport::Client
  end

  it 'should initialize the client from settings' do
    expect(LogData::Source).to receive(:new).with(
      settings['host'],
      settings['port'],
      ENV['ELASTIC_CLIENT_USER'],
      ENV['ELASTIC_CLIENT_PASS'],
      settings['scheme']
    )

    LogData::Source.from_settings
  end

end