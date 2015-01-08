class Device < ActiveRecord::Base
  validates :auth_key, presence: true

  has_many :posts
  has_many :suggestions

  has_many :device_posts
  has_many :posts, :through => :device_posts
end
