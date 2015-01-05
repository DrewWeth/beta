class Update < ActiveRecord::Base
  validates :message, presence: true

end
