require_relative '../ip_location'

module Analyzer
  module Geographical
    module_function

    def access_count_by(field, records)
       Hash[activity_by_ip(records).map { |ip, count| 
         [ Tools::Geolocator.locate(ip).send(field), count ] 
        }]
    end

    def access_data(records)
      activity_by_ip(records).map do |ip, count| 
        AccessCount.new(ip, count)
      end
    end

    private_class_method

    class AccessCount
      attr_reader :ip_location, :count

      def initialize(ip, count)
        @ip_location = Tools::Geolocator.locate(ip)
        @count       = count
      end

      def to_json
        {
          "ip_location" => ip_location.to_json,
          "count"       => count,
        }
      end
    end

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
  end
end
