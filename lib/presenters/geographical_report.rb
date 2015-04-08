module Presenters
  module GeographicalReport
    module_function

    def default
      es        =  LogData::Source.from_settings.retrieve_fields([:ip])
      records   =  LogData::Record.from_source(es)
      raw_data  =  AnalyticEngines::Geographical.generate_access_data_from(records)
      
      raw_data.map(&:to_json)
    end
  end
end