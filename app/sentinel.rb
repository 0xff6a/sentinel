require 'sinatra/base'
require 'sinatra/json'

Dir[File.join(__dir__, '../lib', '/*/*.rb')].each {|file| require file }

class Sentinel < Sinatra::Base
  get '/' do
    'Hello Sentinel World'
  end

  get '/dashboards/geographical' do 
    erb :'dashboards/geographical'
  end

  get '/api/dashboards/geographical' do
    data            = LogData::Record.from_source(
                        LogData::Source.from_settings.retrieve_fields([:ip])
                      )
    @access_coords  = Analyzer::Geographical.activity_by_coords(data)
    @access_coords.map!(&:to_json)

    json({ status: '200', data: @access_coords })
  end

  # start the server if ruby file executed directly
  run! if app_file == $0
end