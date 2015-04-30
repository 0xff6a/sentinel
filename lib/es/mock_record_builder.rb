require_relative 'mock_record'

module ES
  module MockRecordBuilder
    module_function
    DEFAULT_SIZE   = 10

    def random(fields = [])
      (1..DEFAULT_SIZE).to_a.map{ |_| random_record(fields) }
    end

    private_class_method

    def random_record(fields)
      if fields.empty?
        ES::MockRecord.default 
      else
        ES::MockRecord.with_fields(fields.map(&:to_sym))
      end
    end
  end
end