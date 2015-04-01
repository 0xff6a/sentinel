module LogData
  class QueryBuilder
    DEFAULT_WINDOW_DAYS = 30

    def self.default
      default_start = (Time.now - (DEFAULT_WINDOW_DAYS * 24 * 60 * 60)).to_i
      new(default_start, "now", "*")  
    end

    def initialize(time_from, time_to, query_string)
      @time_from     = time_from
      @time_to       = time_to
      @query_string  = query_string
    end

    def query
      {
        filtered: {
          query:  { bool: { should: [{ query_string: { query: @query_string }}] } },
          filter: { bool: { must: [{ 
                              range: { "@timestamp" => {
                              from: @time_from,
                              to: @time_to
                            }}},
                              { fquery: { query: { query_string: { query: "type:(\"rails\")" } }, 
                            }}]
                          }
                        }}
      }
    end
  end
end