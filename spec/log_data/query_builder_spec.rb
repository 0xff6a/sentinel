require 'spec_helper'

describe LogData::QueryBuilder do
  let(:query_s) { LogData::QueryString.default                  }
  let(:builder) { LogData::QueryBuilder.new([:ip], query_s, 25) }

  context 'Setup' do
    it 'can be initialized with a list of fields,a QueryString and a size' do
      expect(builder.query_s).to eq query_s
      expect(builder.size).to eq 25
    end

    it 'can format the fields into ES query syntax' do
      expect(builder.fields).to eq LogData::QueryBuilder::DEFAULT_FIELDS + ['@fields.ip']
    end

    it 'can create a basic query string' do
      basic = LogData::QueryBuilder.basic([])

      expect(basic.query_s).to be_an_instance_of(LogData::QueryString)
      expect(basic.size).to eq LogData::QueryBuilder::DEFAULT_SIZE
      expect(basic.fields).to eq LogData::QueryBuilder::DEFAULT_FIELDS
    end
  end  

  context '#query' do
    it 'outputs a full ES query as json' do

    end
  end                                     
end