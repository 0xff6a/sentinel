require 'sinatra/base'

require_relative 'mock_record_builder'

module ES
  class MockApiServer < Sinatra::Base
    RECORDS = []

    configure do
      set :lock, true
      set :root, File.dirname(__FILE__)
      set :views, Proc.new { File.join(root, 'templates') }
    end

    get '/' do
      '[+] ES::MockApiServer is running'
    end

    put '/reset' do
      RECORDS.clear
      '[+] ES::MockApiServer reset successful'
    end

    get '/retrieve_all' do
      @records = ES::MockRecordBuilder.random

      RECORDS  << @records

      erb :'api_response.json'
    end

    get '/retrieve_fields/:fields' do |fields|
      @records = ES::MockRecordBuilder.random(fields.split(':'))
      
      RECORDS  << @records

      erb :'api_response.json'
    end
  end
end