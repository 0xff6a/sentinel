require 'elasticsearch'

require_relative 'query_builder'
require_relative '../settings'
require_relative '../data_source'

module LogData
  class Source < DataSource
    INDEX_TYPE      = /logstash/
    DEFAULT_FIELDS  = ["@timestamp"]

    attr_reader :client

    def self.from_settings
      new( 
        Settings.elasticsearch_client.host, 
        Settings.elasticsearch_client.port 
      )
    end

    def available?
      res = @client.perform_request('GET', '_cat/indices?v')
      res.status == 200 ? true : false

      rescue *ERR_TO_CATCH
        false
    end

    def retrieve_all
      retrieve(indices, ["*"])
    end

    def retrieve_fields(fields)
      retrieve(indices, fields)
    end

    private

    def indices
      @client
        .perform_request('GET', '_stats/indices')
        .body['indices']
        .keys
        .select { |i| i =~ INDEX_TYPE}
    end

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
