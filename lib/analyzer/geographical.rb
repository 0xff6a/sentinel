module Analyzer
  module Geographical
    module_function

    def activity_by_country(records)
      Hash[activity_by_ip(records).map { |ip, count| 
        [ Tools::Geolocator.locate(ip).country, count ] 
      }]
    end

    private_class_method

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
