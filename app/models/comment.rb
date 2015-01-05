class Comment < ActiveRecord::Base

  validates :comment, presence: true
  validates :device_id, presence: true
  validates :post_id, presence: true




end
