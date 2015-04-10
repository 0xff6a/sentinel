require 'uri'
require 'net/http'

require_relative '../settings'

module ES
  class MockSource
    attr_reader :host, :port

    def self.from_settings
      new( 
        Settings.mock_api.host, 
        Settings.mock_api.port 
      )
    end

    def initialize(host, port)
      @host = host
      @port = port
    end

    def retrieve(n)
      Net::HTTP.get(retrieval_uri)
    end

    private

    def retrieval_uri(n)
      URI.parse("#{host}:#{port}/retrieve/#{n}") 
    end
  end
end
