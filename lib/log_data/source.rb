require 'elasticsearch'
require 'settings'

require_relative 'query_builder'

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
          query: query
        }
      })
    end

    def format_field(f)
      "@fields." + f.to_s
    end
  end
end
