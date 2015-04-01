require 'elasticsearch'
require 'settings'
require 'json'

require_relative 'query_builder'

module LogData
  class Source
    INDEX_TYPE      = /logstash/

    attr_reader :client

    def self.from_settings
      s = Settings.elasticsearch_client

      new( s.host,
           s.port )
    end

    def initialize(host, port)
      @client = Elasticsearch::Client.new({ 
          host: host,
          port: port,
        })
    end

    def indices
      @client
        .perform_request('GET', '_stats/indices')
        .body['indices']
        .keys
        .select { |i| i =~ INDEX_TYPE}
    end

    def retrieve_default
      @client.search({
        index: indices,
        body: {
          query: QueryBuilder.default.query
        }
      })
    end
  end
end
