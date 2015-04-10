require 'uri'
require 'net/http'
require 'json'

require_relative '../settings'
require_relative '../data_source'

module ES
  class MockSource < DataSource
    attr_reader :host, :port

    def self.from_settings
      new( 
        Settings.mock_api.host, 
        Settings.mock_api.port 
      )
    end

    def available?
      res = request("#{host}:#{port}/")

      res.code =~ /^2/ ? true : false

      rescue *ERR_TO_CATCH
        false
    end

    def retrieve(n)
      res = request("#{host}:#{port}/retrieve/#{n}")

      if res.code =~ /^2/
        JSON.parse(res.body)
      else 
        raise MockAPIFailure
      end

      rescue *ERR_TO_CATCH
        raise MockAPIFailure
    end

    private

    def initialize(host, port)
      @host = host
      @port = port
    end

    def request(uri_s)
      uri = URI.parse(uri_s)

      Net::HTTP.start(uri.host, uri.port) do |http|
        req = Net::HTTP::Get.new(uri)
        http.request(req) 
      end
    end

    class MockAPIFailure < StandardError
      def initialize
        super('Mock ES API failed to respond as expected')
      end
    end
  end
end

