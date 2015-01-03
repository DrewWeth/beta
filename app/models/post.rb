class Post < ActiveRecord::Base
  # Geo Factory initialization
  GEO_FACTORY = RGeo::Geographic.spherical_factory(srid: 4326)

  # Validations
  validates :content, presence: true
  validates :latlon, presence: true
  validates :device_id, presence: true
  after_initialize :init
  after_validation :reverse_geocode, if: ->(obj){ obj.latlon.present? and obj.latlon_changed? }

  # Table relations
  belongs_to :device

  # Makes point geographic
  set_rgeo_factory_for_column(:latlon, GEO_FACTORY)

  # Function to auto-fetch the address of a post
  reverse_geocoded_by :latitude, :longitude do |record, results|
    if result = results.first
      new_address = result.city + ", " +  result.state + ", " + result.country
      puts results.inspect
      record.address = new_address # Store the address used for geocoding
      record.city = result.city
      record.latlon = GEO_FACTORY.point(result.longitude, result.latitude)
    end
  end

  def init
    self.latlon ||= GEO_FACTORY.point(0, 0)
  end

  # Helpful longitude methods
  def longitude
    self.latlon.lon
  end

  # Has to have slightly (=) different name than method above
  def longitude=(value)
    lat = self.latlon.lat
    self.latlon = GEO_FACTORY.point(value, lat)
  end

  # Helpful latitude methods
  def latitude
    self.latlon.lat
  end

  # Has to have slightly (=) different name than method above
  def latitude=(value)
    lon = self.latlon.lon
    self.latlon = GEO_FACTORY.point(lon, value)
  end

  def get_latlong_as_string
    "#{self.latitude} #{self.longitude}"
  end

end
