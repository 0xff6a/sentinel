module ES
  module MockRecordBuilder
    module_function
    MockRecord = Struct.new(:timestamp, :method, :path, :ip)

    def random(n)
      (1..n).to_a.map{ |_| random_record }
    end

    private_class_method

    def random_record
      MockRecord.new(
        random_timestamp,
        'GET',
        '/',
        random_ip
      )
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
end