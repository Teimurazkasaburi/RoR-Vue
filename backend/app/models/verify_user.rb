class VerifyUser < ApplicationRecord
	belongs_to :user
  has_one_attached :cac
  has_one_attached :bill
end
