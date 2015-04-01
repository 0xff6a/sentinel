require 'elasticsearch'
require 'settings'
require 'json'

module LogData
  class Source
    LOG_TYPE = /logstash/

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
      client
        .perform_request('GET', '_stats/indices')
        .body['indices']
        .keys
        .select { |i| i =~ LOG_TYPE}
    end

    def retrieve_default
      client.search({
        index: indices,
        body: {
          query: default_query
        }
      })
    end

    private

    def default_query
      {
        filtered: {
          query:  { bool: { should: [{ query_string: { query: "*" }}] } },
          filter: { bool: { must: [{ 
                              range: { "@timestamp" => {
                              from: 1425310414146,
                              to: "now"
                            }}},
                              { fquery: { query: { query_string: { query: "type:(\"rails\")" } }, 
                            }}]
                          }
                        }}
      }
    end
  end
end
