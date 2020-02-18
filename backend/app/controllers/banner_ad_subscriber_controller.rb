require 'httparty'

class BannerAdSubscriberController < ApplicationController
  before_action :authenticate_user

  def subscriber
    banner_ad = BannerAd.find_by_ref_no(params[:id])
    type = banner_ad.banner_type
    amount = banner_ad.amount

		case 
      when type == "SMALL"
        small banner_ad
			when type == "MEDIUM"
        medium banner_ad
      when type == "LARGE"
        large banner_ad
			else
				render "Unknown banner"		
		end


  end


  private

  def small banner_ad
    ref_no = banner_ad.ref_no
    price = 130000
    duration = banner_ad.duration
    due_amount = total_due price, duration
    user = banner_ad.user

  
    if verify_transaction due_amount, ref_no
      banner_subscription = banner_ad.update_attributes(expiring_date: Time.now + duration*30.day, status: "ACTIVE")
      render json: { status: "banner ads created"}
      SubscriptionMailer.bannerAd(user, banner_subscription).deliver_later
    else
      render json: { status: "unsuccessful", message: "Can not verify payment" }, status: :unprocessable_entity
    end
  end


  def medium banner_ad
    ref_no = banner_ad.ref_no
    price = 150000
    duration = banner_ad.duration
    due_amount = total_due price, duration
    user = banner_ad.user

  
    if verify_transaction due_amount, ref_no
      banner_subscription = banner_ad.update_attributes(expiring_date: Time.now + duration*30.day, status: "ACTIVE")
      render json: { status: "banner ads created"}
      SubscriptionMailer.bannerAd(user, banner_subscription).deliver_later
    else
      render json: { status: "unsuccessful", message: "Can not verify payment" }, status: :unprocessable_entity
    end
  end


  def large banner_ad
    ref_no = banner_ad.ref_no
    price = 170000
    duration = banner_ad.duration
    due_amount = total_due price, duration
    user = banner_ad.user

  
    if verify_transaction due_amount, ref_no
      banner_subscription = banner_ad.update_attributes(expiring_date: Time.now + duration*30.day, status: "ACTIVE")
      render json: { status: "banner ad created"}
      SubscriptionMailer.bannerAd(user, banner_subscription).deliver_later
    else
      render json: { status: "unsuccessful", message: "Can not verify payment" }, status: :unprocessable_entity
    end
  end




  def total_due price, duration
    if duration >= 6 && duration < 12
      return (price * duration) - ((price * duration) * 5/100)

    elsif duration >= 12
      return (price * duration) - ((price * duration) * 10/100)
  
    else
      return price * duration
    end
  end
  
  def verify_transaction due_amount, ref_no

    response = HTTParty.get("https://api.paystack.co/transaction/verify/#{ref_no}", 
                  headers: { "Authorization"=> "Bearer #{Rails.application.credentials.dig(:paystack, :secret_key)}",
                  "content-type" => "application/json"})

                  # render json: response['data']['amount']
    paid = response['data']['amount']/100
    status = response['data']['status']
    if paid == due_amount && status == 'success'
      puts "#{status} from paystack"
      puts "#{paid} Amount paid from paystack"
      return true
    end
  end
end
