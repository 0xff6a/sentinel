require 'spec_helper'

describe LogData::QueryString do   
  let(:start_time) { (Time.now - (LogData::QueryString::DEFAULT_WINDOW_DAYS * 24 * 60 * 60)).to_i * 1000 }
  let(:query_s)    { LogData::QueryString.new(start_time, 'now', 'attribute')                            }

  context 'Setup' do
    it 'can be initialized with a start time, end time and text' do
      expect(query_s.time_from).to eq start_time
      expect(query_s.time_to).to eq 'now'
      expect(query_s.text).to eq 'attribute'
    end

    it 'can create a default query string' do
      q = LogData::QueryString.default

      expect(q.time_from).to be_within(1).of(start_time)
      expect(q.time_to).to eq 'now'
      expect(q.text).to eq '*'
    end
  end

  context '#to_json' do
    let(:query_j) do
      {
        filtered: {
          query:  { bool: { should: [{ query_string: { query: 'attribute'}}] } },
          filter: { bool: { must: [{ 
              range: { :@timestamp => {
              from: start_time,
              to: 'now'
            }}},
              { fquery: { query: { query_string: { query: "type:(\"rails\")" } }, 
            }}]
          }
        }}
      }
    end

    it 'outputs a json elastic search query string' do
      expect(query_s.to_json).to eq query_j
    end
  end
end