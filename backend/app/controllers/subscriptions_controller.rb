require 'httparty'


class SubscriptionsController < ApplicationController
  before_action :authenticate_user

  def subscriber
    transaction = Transaction.find_by_ref_no(params[:id])
    plan = transaction.transaction_for
    amount = transaction.amount

		case 
      when plan == "BASIC"
        basic transaction
      when plan == "CLASSIC"
        classic transaction
			when plan == "PRO"
        pro transaction
      when plan == "CUSTOM"
        custom transaction
      when plan == "PRIORITY"
        priority transaction
      when plan == "BOOST"
        boost transaction
			else
				render "Unknown plan"		
		end


  end

  def index
    user = User.find_by_username(params[:id])

    if user == current_user || current_user.admin
      @subscription = user.subscription
      @transactions = user.transactions.paginate(:page => params[:page], :per_page => 2)
      render :index
    else
      render json:   { message: "You're not authorized to access this resources" }, status: :unauthorized
    end
    
  end


  private

  def basic transaction
    ref_no = transaction.ref_no
    price = 2000
    duration = transaction.duration
    due_amount = total_due price, duration
    user = transaction.user
  
    if verify_transaction due_amount, ref_no
      subscription = user.build_subscription(plan: transaction.transaction_for, amount: due_amount, expiring_date: Time.now + duration*30.day, start_date: Time.now, boost: duration*5, priorities: duration*5, max_post: duration*1000)
      if subscription.save
        render json: { status: "subscription created"}
        transaction.update_attributes(status: "PAID")
        SubscriptionMailer.invoice(user, transaction, subscription).deliver_later
      end
    else
      render json: { status: "unsuccessful", message: "Can not verify payment" }, status: :unprocessable_entity
    end
  end

  def classic transaction
    ref_no = transaction.ref_no
    price = 5000
    duration = transaction.duration
    due_amount = total_due price, duration
    user = transaction.user
  
    if verify_transaction due_amount, ref_no
      subscription = user.build_subscription(plan: transaction.transaction_for, amount: due_amount, expiring_date: Time.now + duration*30.day, start_date: Time.now, boost: duration*10, priorities: duration*15, max_post: duration*1000)
      if subscription.save
        render json: { status: "subscription created"}
        transaction.update_attributes(status: "PAID")
        SubscriptionMailer.invoice(user, transaction, subscription).deliver_later
      end
    else
      render json: { status: "unsuccessful", message: "Can not verify payment" }, status: :unprocessable_entity
    end
  end

  def pro transaction
    ref_no = transaction.ref_no
    price = 12500
    duration = transaction.duration
    due_amount = total_due price, duration
    user = transaction.user
  
    if verify_transaction due_amount, ref_no
      subscription = user.build_subscription(plan: transaction.transaction_for, amount: due_amount, expiring_date: Time.now + duration*30.day, start_date: Time.now, boost: duration*20, priorities: duration*40, max_post: duration*1000)
      if subscription.save
        render json: { status: "subscription created"}
        transaction.update_attributes(status: "PAID")
        SubscriptionMailer.invoice(user, transaction, subscription).deliver_later

      end
    else
      render json: { status: "unsuccessful", message: "Can not verify payment" }, status: :unprocessable_entity
    end
  end

  def custom transaction
    ref_no = transaction.ref_no
    price = 20000
    duration = transaction.duration
    due_amount = total_due price, duration 
    user = transaction.user
  
    if verify_transaction due_amount, ref_no
      subscription = user.build_subscription(plan: transaction.transaction_for, amount: due_amount, expiring_date: Time.now + duration*30.day, start_date: Time.now, boost: duration*30, priorities: duration*60, max_post: duration*1000)
      if subscription.save
        render json: { status: "subscription created"}
        transaction.update_attributes(status: "PAID")
        SubscriptionMailer.invoice(user, transaction, subscription).deliver_later
      end
    else
      render json: { status: "unsuccessful", message: "Can not verify payment" }, status: :unprocessable_entity
    end
  end


  def priority transaction
    ref_no = transaction.ref_no
    price = 500
    duration = transaction.duration
    due_amount = price * duration 
    user = transaction.user

    if verify_transaction due_amount, ref_no
      subscription = user.subscription.update_attributes(priorities: duration)
      if subscription.save
        render json: { status: "additional priority successful"}
        transaction.update_attributes(status: "PAID")
        SubscriptionMailer.invoice(user, transaction, subscription).deliver_later
      end
    else
      render json: { status: "unsuccessful", message: "Can not verify payment" }, status: :unprocessable_entity
    end
  end



  def boost transaction
    ref_no = transaction.ref_no
    price = 500
    duration = transaction.duration
    due_amount = price * duration 
    user = transaction.user
  
    if verify_transaction due_amount, ref_no
      subscription = user.subscription.update_attributes(boost: duration)
      if subscription.save
        render json: { status: "additional boost successful"}
        transaction.update_attributes(status: "PAID")
        SubscriptionMailer.invoice(user, transaction, subscription).deliver_later
      end
    else
      render json: { status: "unsuccessful", message: "Can not verify payment" }, status: :unprocessable_entity
    end
  end


  def total_due price, duration
    if duration >= 3 && duration < 6
      return (price * duration) - ((price * duration) * 5/100)

    elsif duration >= 6 && duration < 12
      return (price * duration) - ((price * duration) * 10/100)

    elsif duration >= 12
      return (price * duration) - ((price * duration) * 15/100)
  
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
      return true
    end
  end
end
