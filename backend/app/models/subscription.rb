class Subscription < ApplicationRecord
  belongs_to :user, optional: true

	scope :expired, -> { where("expiring_date < ?", Time.now).where.not(expiring_date: nil).where.not(user_id: nil) }
end
