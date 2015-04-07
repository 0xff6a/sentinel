module Presenters
  module GeographicalReport
    module_function

    def default
      es_records =  LogData::Record.from_source(
                      LogData::Source.from_settings.retrieve_fields([:ip])
                    )
      raw_data   =  Analyzer::Geographical.access_data(es_records)
      raw_data.map(&:to_json)
    end
  end
end