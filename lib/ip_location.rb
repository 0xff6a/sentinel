class IPLocation
  attr_reader :ip, :country, :lat, :lng

  def self.from_api(response)
    data = JSON.parse(response)

    new(
      data['ip'],
      data['country_code'],
      data['latitude'],
      data['longitude']
    )
  end

  def initialize(ip, country, lat, lng)
    @ip      = ip
    @country = country
    @lat     = lat
    @lng     = lng
  end

  def to_json
    {
      "ip"      => ip,
      "lat"     => lat,
      "lng"     => lng,
      "country" => country
    }
  end
end