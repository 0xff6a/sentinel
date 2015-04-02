module LogData
  class Record
    attr_reader :timestamp, :fields

    def self.from_source
      
    end
    
    def initialize(raw)
      @timestamp = raw['@timestamp']
      @fields    = raw['@fields']
    end
  end
end