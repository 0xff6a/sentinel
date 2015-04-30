require 'json'

module ES
  class MockRecord
    class << self
      def default
        new(
          default_fields,
          random_timestamp
        )
      end

      def with_fields(fields)
        new(
          filtered_fields(fields),
          random_timestamp
        )
      end

      private

      def filtered_fields(fields)
        default_fields.select { |field, value| fields.include?(field) }
      end

      def default_fields
        @default_fields ||=
          {
            method:     "GET",
            path:       "/",
            format:     "html",
            controller: "root",
            action:     "index",
            status:     0,
            duration:   0.45,
            ip:         random_ip,
            route:      "root#index",
            request_id: "adcac23f-a7a8-4775-a29a-fe767a60a971"
          }
      end

      def random_timestamp
        (DateTime.now - ( 30 * rand() )).to_s
      end 

      def random_ip
        "#{random_octet}.#{random_octet}.#{random_octet}.#{random_octet}"
      end

      def random_octet
        (rand * 252).to_i
      end
    end

    attr_reader :fields, :timestamp

    def initialize(fields_h, timestamp)
      @fields    = OpenStruct.new(fields_h)
      @timestamp = timestamp
    end

    def fields_to_json
      fields.to_h.to_json
    end
  end
end