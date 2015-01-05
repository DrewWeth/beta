class DevicePost < ActiveRecord::Base
  validates :post_id, presence: true
  validates :device_id, presence: true

end
