require 'sinatra/base'

require_relative '../es/mock_record_builder'

module MockApi
  class Server < Sinatra::Base
    # ===================================================================================
    # Configuration
    # ===================================================================================
    
    configure do
      set :lock, true
      set :root, File.dirname(__FILE__)
      set :views, Proc.new { File.join(root, 'templates') }
    end

    # ===================================================================================
    # Elasticsearch Mock API
    # ===================================================================================
    
    RECORDS = []

    get '/' do
      '[+] MockApi::Server is running'
    end

    put '/es/reset' do
      RECORDS.clear
      '[+] MockApiServer ES data reset successful'
    end

    get '/es/retrieve_all' do
      @records = ES::MockRecordBuilder.random

      RECORDS  << @records

      erb :'es/api_response.json'
    end

    get '/es/retrieve_fields/:fields' do |fields|
      @records = ES::MockRecordBuilder.random(fields.split(':'))
      
      RECORDS  << @records

      erb :'es/api_response.json'
    end

    # ===================================================================================
    # IP Location Mock API
    # ===================================================================================
    
    get '/geolocation/:ip' do |ip|

      unless ip && ip =~ /\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b/
        status 400 
        body '[-] Bad IP provided'
      else
        @ip  = ip
        @lat = random_lat
        @lng = random_lng

        erb :'geolocation/api_response.json'
      end
    end

    private

    def random_lat
      (90 - rand * 180).round(2)
    end

    def random_lng
      (180 - rand * 360).round(2)
    end
  end
end