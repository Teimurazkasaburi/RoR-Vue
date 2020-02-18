class Brand < ApplicationRecord
  has_one_attached :logo
  belongs_to :user
  after_create :generate_reference

	scope :home, -> { where(status: "ACTIVE") }

  def self.logo
		{   
      strip: true,
      'sampling-factor': '4:2:0',
      quality: '45',
      interlace: 'JPEG',
      colorspace: 'sRGB'
    }
	end

  def generate_reference
  	self.update_attributes(ref_no: "PB-#{rand(36**16).to_s(26).upcase}")
	end
end
