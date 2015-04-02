require 'net/http'
require 'json'

module Tools
  module Geolocator
    module_function
    BASE_URL = 'http://freegeoip.net/json/'

    def bulk_locate(ips)
      # TODO: make this a lot cleverer to handle many IPs!
      ips.map { |ip|  locate(ip) }
    end

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

    def call_api(ip)
      uri = URI.parse(BASE_URL + ip.to_s)

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

    class IPLocation
      attr_reader :ip, :country_code, :lat, :lng

      def self.from_api(response)
        data = JSON.parse(response)

        new(
          data['ip'],
          data['country_code'],
          data['latitude'],
          data['longitude']
        )
      end

      def initialize(ip, country_code, lat, lng)
        @ip           = ip
        @country_code = country_code
        @lat          = lat
        @lng          = lng
      end
    end
  end
end
