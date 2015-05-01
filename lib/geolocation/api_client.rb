require 'net/http'
require 'json'

require_relative '../ip_location'

module Geolocation
  module ApiClient
    module_function
    HOST = Settings.geolocation_api.host
    PORT = Settings.geolocation_api.port 

    def locate(ip)
      res = call_api(ip)
      IPLocation.from_api(res)
    end

    class GeolocationDataLimitExceeded < StandardError 
      def initialize
        super('API calls have exceeded 10,000/hour limit. Please wait 60mins before retrying')
      end
    end

    class GeolocationAPIError < StandardError
      def initialize
        super('The API response could not be processed')
      end
    end

    private_class_method

    def build_uri(ip)
      uri      = URI.parse(HOST + '/' + ip.to_s)
      uri.port = PORT
      uri
    end

    def call_api(ip)
      uri = build_uri(ip)

      Net::HTTP.start(uri.host, uri.port) do |http|
        req = Net::HTTP::Get.new(uri)
        res = http.request(req) 

        case res.code
        when /^2/
          res.body
        when /403/
          raise GeolocationDataLimitExceeded
        else 
          raise GeolocationAPIError
        end
      end
    end
  end
end
