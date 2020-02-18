class Marker < ApplicationRecord
	belongs_to :user
  belongs_to :post
  
  scope :bookmarks, -> { where(type_of_maker: "BOOKMARK") }
	scope :reported, -> { where(type_of_maker: "REPORTED") }
  
  validates :user_id, uniqueness: { scope: [:post_id]}

end
