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
      retrieve(indices, ["*"])
    end

    def retrieve_fields(fields)
      retrieve(indices, fields)
    end

    private

    def initialize(host, port)
      @client = Elasticsearch::Client.new({ 
        host: host,
        port: port,
      })
    end

    def retrieve(indices, fields)
      @client.search(
        { index: indices }
        .merge(QueryBuilder.basic(fields).query)
      )
    end
  end
end
