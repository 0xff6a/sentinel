require 'elasticsearch'
require 'settings'

module LogData
  class Source
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
  end
end