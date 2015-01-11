class Post < ActiveRecord::Base
  # Geo Factory initialization

  GEO_FACTORY = RGeo::Geographic.spherical_factory(srid: 4326)

  # Validations
  validate :has_content

  validates :latlon, presence: true
  validates :device_id, presence: true
  after_initialize :init
  after_validation :reverse_geocode, if: ->(obj){ obj.latlon.present? and obj.latlon_changed? }
  before_validation :calculate_radius

  # Table relations
  belongs_to :device
  has_many :reports
  has_many :comments

  has_many :device_posts
  has_many :devices, :through => :device_posts


  # Makes point geographic
  set_rgeo_factory_for_column(:latlon, GEO_FACTORY)

  # Function to auto-fetch the address of a post
  reverse_geocoded_by :latitude, :longitude do |record, results|
    if result = results.first
      if !result.nil?
        new_address = result.city + ", " +  result.state + ", " + result.country
        puts results.inspect
        record.address = new_address # Store the address used for geocoding
        record.city = result.city
        record.latlon = GEO_FACTORY.point(result.longitude, result.latitude)
      else
        record.address = "NA"
        record.city = "NA"
      end
    end
  end

  def calculate_radius
    puts "calculating radius!!"
    radius = 3219.0 + 400 * self.ups + 100 * self.views
    radius -= 300 * self.downs unless self.constraint == 2 # unless is an advert
    self.radius = radius

    if self.downs - self.ups > 5 and self.constraint != 2 # If net upvotes is greater than -5 then remove/ban the post
      self.constraint = 1 # Banned post
    end
  end


  def has_content
    if [self.content, self.post_url].reject(&:blank?).size == 0
      errors[:base] << ("Please enter text or an image")
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
