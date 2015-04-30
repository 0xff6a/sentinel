require 'spec_helper'

describe ES::MockRecordBuilder do
  let(:size) { ES::MockRecordBuilder::DEFAULT_SIZE }

  it 'can build an array of random MockRecord objects with default fields' do
    expect(ES::MockRecord).to receive(:default).exactly(size).times
    recs = ES::MockRecordBuilder.random
    expect(recs.size).to eq size
  end

  it 'can build an array of random MockRecord objects with specified fields' do
    fields = [:ip, :duration]
    
    expect(ES::MockRecord).to receive(:with_fields).with(fields).exactly(size).times
    recs = ES::MockRecordBuilder.random(fields)
    expect(recs.size).to eq size
  end
end