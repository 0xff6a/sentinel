require 'spec_helper'

describe ES::MockRecordBuilder do
  let(:ip_regex) { /\b(?:\d{1,3}\.){3}\d{1,3}\b/ }

  it 'can create a random MockRecord object' do
    rec = ES::MockRecordBuilder.random(1).first
    
    expect(rec.path).to eq '/'
    expect(rec.method).to eq 'GET'
    expect(rec.ip).to match ip_regex
    expect(DateTime.parse(rec.timestamp)).to be_an_instance_of DateTime 
  end

  it 'can build an array of random MockRecord objects' do
    recs = ES::MockRecordBuilder.random(10)

    expect(recs.size).to eq 10
    expect(recs.all? { |record|
      record.ip =~ ip_regex
    }).to be true
  end
end