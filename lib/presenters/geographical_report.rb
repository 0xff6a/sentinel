module Presenters
  module GeographicalReport
    module_function

    def default
      es        =  LogData::Source.from_settings.retrieve_fields([:ip]
      records   =  LogData::Record.from_source(source)
      raw_data  =  Analyzer::Geographical.access_data(es_records)
      
      raw_data.map(&:to_json)
    end
  end
end