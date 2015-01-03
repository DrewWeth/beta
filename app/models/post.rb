class Post < ActiveRecord::Base

  validates :content, presence: true
  validates :latlon, presence: true
  validates :device_id, presence: true

  belongs_to :device

  set_rgeo_factory_for_column(:latlon, RGeo::Geographic.spherical_factory(:srid => 4326))

end
