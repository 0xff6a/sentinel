module Presenters
  module GeographicalReport
    module_function

    def default
      es        =  Sentinel::DataSource.from_settings.retrieve_fields([:ip])
      records   =  LogData::Record.from_es_data(es)
      raw_data  =  AnalyticEngines::Geographical.generate_access_data_from(records)
      
      raw_data.map(&:to_json)
    end
  end
end