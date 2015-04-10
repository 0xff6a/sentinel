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

    get '/retrieve/:n' do |n|
      @records = ES::MockRecordBuilder.random(n.to_i)
      @total   = n
      RECORDS  << @records

      erb :'api_response.json'
    end
  end
end