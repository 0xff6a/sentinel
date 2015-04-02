module LogData
  class Record
    attr_reader :timestamp, :fields

    def self.from_source(response)
      raw_records = response['hits']['hits']
      raw_records.map { |raw| new(raw['_source']) }
    end
    
    def initialize(raw_h)
      @timestamp = raw_h['@timestamp']
      @fields    = raw_h['@fields']
    end
  end
end