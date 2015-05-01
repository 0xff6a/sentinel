require 'sinatra/base'
require 'sinatra/json'

# Require lib files
Dir[File.join(__dir__, '../lib', '/*/*.rb')].each {|file| require file }
  
class Sentinel < Sinatra::Base
  configure do
    set :root, File.dirname(__FILE__)
  end

  configure :test do
    DataSource = ES::MockSource
  end

  configure :production, :development do
    DataSource = LogData::Source
    Geolocation::Service.load_cache!
  end

  get '/' do
    'Hello Sentinel World'
  end

  get '/dashboards/geographical' do 
    erb :'dashboards/geographical'
  end

  get '/api/dashboards/geographical' do
    access_data = Presenters::GeographicalReport.default

    json({ status: '200', data: access_data })
  end

  # start the server if ruby file executed directly
  run! if app_file == $0
end