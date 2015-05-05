module LogData
  class QueryString
    DEFAULT_WINDOW_DAYS = 10

    attr_reader :time_from, :time_to, :text

    def self.default
      default_start = (Time.now - (DEFAULT_WINDOW_DAYS * 24 * 60 * 60)).to_i * 1000
      new(default_start, 'now', '*')  
    end

    def initialize(time_from, time_to, text)
      @time_from = time_from
      @time_to   = time_to
      @text      = text
    end

    def to_json
      {
        filtered: {
          query:  { bool: { should: [{ query_string: { query: @text}}] } },
          filter: { bool: { must: [{ 
              range: { :@timestamp => {
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