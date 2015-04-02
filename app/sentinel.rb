require 'sinatra/base'

Dir[File.join(__dir__, '../lib', '/*/*.rb')].each {|file| require file }

class Sentinel < Sinatra::Base
  get '/' do
    'Hello Sentinel World'
  end

  get '/dashboards/geographical' do
    data               = LogData::Record.from_source(
                          LogData::Source.from_settings.retrieve_fields([:ip])
                        )
    @access_by_country = Analyzer::Geographical.activity_by_country(data)
   
    erb :'dashboards/geographical'
  end

  # start the server if ruby file executed directly
  run! if app_file == $0
end