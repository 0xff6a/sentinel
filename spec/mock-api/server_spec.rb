require 'spec_helper'
require 'net/http'

describe MockApi::Server do
  context 'Hearbeat endpoint:' do
    it 'should respond to the hearbeat endpoint' do
      res = perform_get('/')

      expect(res.code).to eq '200'
      expect(res.body).to eq '[+] MockApi::Server is running'
    end
  end

  context 'Elastic search mock:' do
    it 'should return random records with all fields'

    it 'should return random records with selected fields'  
  end

  context 'Geolocation mock:' do
    it 'should return a JSON gelocation response given an IP address' do
      res = perform_get('/geolocation/10.1.234.6')
      body = JSON.parse(res.body)

      expect(body.delete('latitude').to_s).to match /\d+.\d+/
      expect(body.delete('longitude').to_s).to match /\d+.\d+/
      expect(res.code).to eq '200'
      expect(body).to eq({
        "ip"=>"10.1.234.6", 
        "country_code"=>"TT", 
        "country_name"=>"", 
        "region_code"=>"", 
        "region_name"=>"", 
        "city"=>"", 
        "zip_code"=>"", 
        "time_zone"=>"XYZ", 
        "metro_code"=>0
      })
    end

    it 'should return a 404 error if no ip is provided' do
      res = perform_get('/geolocation/')

      expect(res.code).to eq '404'
      expect(res.body).to eq '<h1>Not Found</h1>'
    end

    it 'should return a 400 error if an invalid ip is provided' do
      res = perform_get('/geolocation/jfkldanlfd')

      expect(res.code).to eq '400'
      expect(res.body).to eq '[-] Bad IP provided'
    end
  end

  def perform_get(path)
    uri = URI.parse("#{Settings.mock_api.host}:#{Settings.mock_api.port}#{path}")

    Net::HTTP.start(uri.host, uri.port) do |http|
      req = Net::HTTP::Get.new(uri)
      http.request(req) 
    end
  end
end