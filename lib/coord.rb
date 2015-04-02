class Coord
  attr_reader :lat, :lng, :country

  def self.from_iplocation(iplocation)
    new(
      iplocation.lat, 
      iplocation.lng, 
      iplocation.country
    )
  end

  def initialize(lat, lng, country)
    @lat      = lat
    @lng      = lng
    @country  = country
  end

  def to_json
    {
      "lat" =>     lat,
      "lng" =>     lng,
      "country" => country
    }
  end
end