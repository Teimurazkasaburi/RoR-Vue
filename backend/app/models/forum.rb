class Forum < ApplicationRecord
	before_create :generate_permalink
  searchkick
  belongs_to :user
	has_many :comments, dependent: :destroy


private


  def generate_permalink
		pattern=self.subject.parameterize
		duplicates = Forum.where('permalink like ?', "%#{pattern}%")

		if duplicates.present?
			self.permalink = "#{pattern}-#{duplicates.count+1}"
		else
			self.permalink = pattern
    end

  end 
end