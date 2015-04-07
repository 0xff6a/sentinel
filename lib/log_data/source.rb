require 'elasticsearch'

require_relative 'query_builder'
require_relative '../settings'

module LogData
  class Source
    INDEX_TYPE      = /logstash/
    DEFAULT_FIELDS  = ["@timestamp"]

    attr_reader :client

    def self.from_settings
      new( 
        Settings.elasticsearch_client.host, 
        Settings.elasticsearch_client.port 
      )
    end

    def indices
      @client
        .perform_request('GET', '_stats/indices')
        .body['indices']
        .keys
        .select { |i| i =~ INDEX_TYPE}
    end

    def retrieve_all
      retrieve(
        indices,
        QueryBuilder.default.query,
        ["*"]
      )
    end

    def retrieve_fields(fields)
      retrieve(
        indices,
        QueryBuilder.default.query, 
        DEFAULT_FIELDS + fields.map { |f| format_field(f) }
      )
    end

    private

    def initialize(host, port)
      @client = Elasticsearch::Client.new({ 
        host: host,
        port: port,
      })
    end

    def retrieve(indices, query, fields)
      @client.search({
        index: indices,
        body: {
          _source: fields,
          query: query,
          size: 100 # Set as 100 to simplify testing and development
        }
      })
    end

    def format_field(f)
      "@fields." + f.to_s
    end
  end
end
