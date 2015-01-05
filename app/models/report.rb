class Report < ActiveRecord::Base

  validates :device_id, presence: true
  validates :post_id, presence: true
  validates :why, presence: true



end
