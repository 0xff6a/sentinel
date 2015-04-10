require_relative 'query_string'

module LogData
  class QueryBuilder
    DEFAULT_FIELDS  = ["@timestamp"]
    DEFAULT_SIZE    = 200

    attr_reader :fields, :query_s, :size

    def self.basic(fields)
      new(
        fields,
        QueryString.default,             
        DEFAULT_SIZE
      )
    end

    def self.custom(fields, query_params, size)
    end

    def initialize(fields, query_s, size)
      @fields  = DEFAULT_FIELDS + fields.map { |f| format_field(f) }
      @query_s = query_s
      @size    = size
    end

    def query
      {
        body: {
          _source: fields,
          query: query_s.to_json,
          size: size
        }
      }
    end

    private

    def format_field(f)
      "@fields." + f.to_s
    end
  end
end