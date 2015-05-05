module Analyzer
  module Geographical
    module_function

    def activity_by_ip(records)
      records.reduce({}) do |result, record|
        record.fields ? update(result, record) : result
      end
    end

    class AccessCount
      attr_reader :ip_location, :count

      def self.build_from(ip, count)
        new(Geolocation::Service.locate(ip), count)
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

    private_class_method

    def update(result, record)
      ip = record.fields['ip']
      
      if result.has_key?(ip)
        (result[ip] += 1) && result
      else
        result.merge({ip => 1}) 
      end
    end
  end
end
