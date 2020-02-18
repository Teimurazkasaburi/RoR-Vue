require 'httparty'

class BrandSubscriberController < ApplicationController
before_action :authenticate_user

  def subscriber
    brand = Brand.find_by_ref_no(params[:id])
    partner brand
  end


private
def partner brand
    ref_no = brand.ref_no
    price = 200000
    duration = brand.duration
    due_amount = total_due price, duration
    user = brand.user

  
    if verify_transaction due_amount, ref_no
      brand_subscription = brand.update_attributes(expiring_date: Time.now + duration*30.day, status: "ACTIVE")
      render json: { status: "partner brand created"}
      SubscriptionMailer.brand(user, brand_subscription).deliver_later
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
