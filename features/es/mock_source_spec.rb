require 'feature_helper'

describe ES::MockSource do
  let(:src) { ES::MockSource.from_settings }

  it 'can check if ES mock api is running' do
    expect(src.available?).to be true

    allow_any_instance_of(Net::HTTP).to receive(:request).and_raise(Errno::ECONNREFUSED)
    expect(src.available?).to be false
  end

  it 'can retrieve a ES records from the mock api' do
    data    = src.retrieve(1)
    records = LogData::Record.from_source(data)

    expect(records.count).to be 1
    expect(records.all? { |record|
      record.is_a?(LogData::Record) && 
      record.fields['ip'] =~ /\b(?:\d{1,3}\.){3}\d{1,3}\b/
    })
  end

  it 'can handle mock API errors' do
    allow_any_instance_of(Net::HTTP).to receive(:request).and_raise(Errno::ECONNREFUSED)

    expect { src.retrieve(10) }.to raise_error(ES::MockSource::MockAPIFailure)
  end
end