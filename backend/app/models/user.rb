class User < ApplicationRecord
	has_secure_password
	has_many :posts, dependent: :destroy
	has_many :post_requests, dependent: :destroy
	has_many :transactions, dependent: :destroy
	has_many :banner_ads, dependent: :destroy
	has_many :brands, dependent: :destroy
	has_many :markers, dependent: :destroy
	has_many :logs, dependent: :destroy
	has_many :forums, dependent: :destroy
	has_many :comments, dependent: :destroy
	has_one :subscription, dependent: :destroy
	has_many :verify_users, dependent: :destroy
	has_one_attached :avatar
	searchkick
	validates :username, presence: true, :uniqueness => true
	validates :email, presence: true, :uniqueness => true
	attr_accessor :old_password, :new_password

	# scope :sale, -> { where(purpose: "SALE") }
	# scope :rent, -> { where(purpose: "RENT") }
	# scope :short, -> { where(purpose: "SHORT") }
	# scope :development, -> { where(purpose: "NEW") }
	# scope :installment, -> { where(purpose: "INSTALLMENT") }
	scope :agents, -> { where.not(account_type: ["PROPERTY_OWNER", "INDIVIDUAL"], company: false) }




  def self.from_token_request request
		username = request.params["auth"] && request.params["auth"]["username"]
    email = request.params["auth"] &&  request.params["auth"]["email"]

		user = (self.find_by username: username) || ( self.find_by email: email )
		
		if user && user.authenticate(request.params[:auth][:password])
			if user.logs.last
				user.update_attributes(last_logged_in: user.logs.last.time)
			else
				user.update_attributes(last_logged_in: Time.zone.now)
			end
			Log.create!( time: Time.zone.now , user_id: user.id )
			user.update_attributes(logged_in_at: Time.zone.now)
		end

		self.find_by username: username or self.find_by email: email
	end

	def self.avatar
		{
			resize: "500x500", 
			gravity: 'center',
			strip: true,
      'sampling-factor': '4:2:0',
      quality: '85',
      interlace: 'JPEG',
			colorspace: 'sRGB'
		}
	end

	def to_token_payload
    {
      sub: id,
      email: email,
      username: username,
			admin: admin
    }
  end

	def self.check_account_type  user
		account_type = user.account_type
		case 
			when account_type == "INDIVIDUAL"
				return false
			when account_type == "PROPERTY_OWNER"
				return false
			else
				return true			
		end
	end


	def subscribed?
    if self.subscription.plan != "FREE"
      return true
    else
      return false
    end
	end
	

end
