class Transaction < ApplicationRecord
  belongs_to :user
  after_create :generate_reference

  private
  def generate_reference
  	self.update_attributes(ref_no: "#{rand(36**36).to_s(26).upcase}")
	end
end
