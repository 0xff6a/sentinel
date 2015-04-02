require_relative '../coord'

module Analyzer
  module Geographical
    module_function

    # def activity_by_country(records)
    #   Hash[activity_by_ip(records).map { |ip, count| 
    #     [ Tools::Geolocator.locate(ip).country, count ] 
    #   }]
    # end

    def activity_by_coords(records)
      activity_by_ip(records).map do |ip, count| 
        GeoResult.new(ip, count)
      end
    end

    private_class_method

    class GeoResult
      attr_reader :ip, :count, :coord

      def initialize(ip, count)
        @ip    = ip
        @coord = Coord.from_iplocation(Tools::Geolocator.locate(ip))
        @count = count
      end

      def to_json
        {
          "ip"    => ip,
          "count" => count,
          "coord" => coord.to_json
        }
      end
    end

    def activity_by_ip(records)
      records.reduce({}) do |result, record|
        ip = record.fields['ip']

        if result.has_key?(ip)
          (result[ip] += 1) && result
        else
          result.merge({ip => 1}) 
        end
      end
    end
  end
end
