require_relative '../tools/geolocator'

module Analyzer
  module Geographical
    module_function

    def activity_by_ip(records)
      records.reduce({}) do |result, record|
        return result unless record.fields
        ip = record.fields['ip']
        
        if result.has_key?(ip)
          (result[ip] += 1) && result
        else
          result.merge({ip => 1}) 
        end
      end
    end

    class AccessCount
      attr_reader :ip_location, :count

      def self.build_from(ip, count)
        new(Tools::Geolocator.locate(ip), count)
      end

      def initialize(ip_location, count)
        @ip_location = ip_location
        @count       = count
      end

      def to_json
        {
          "ip_location" => ip_location.to_json,
          "count"       => count,
        }
      end
    end
  end
end
