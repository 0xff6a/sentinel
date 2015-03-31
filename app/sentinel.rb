require 'sinatra/base'

Dir[File.join(__dir__, '../lib', '*.rb')].each {|file| require file }

class Sentinel < Sinatra::Base
  get '/' do
    'Hello Sentinel World'
  end

  # start the server if ruby file executed directly
  run! if app_file == $0
end