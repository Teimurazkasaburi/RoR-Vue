class SubscriptionMailer < ApplicationMailer
  def invoice(user, transaction, subscription)
    @user = user
    @transaction = transaction
    @subscription = subscription
    mail(to: @user.email, subject: "your '#{@transaction.transaction_for}' subscription was successfully updated.")
  end

  def bannerAd (user, banner)
    @user = user
    @banner = banner
    mail(to: @user.email, subject: "your '#{@banner.banner_type}' banner ad subscription was successfully updated.")
  end


  def brand (user, brand)
    @user = user
    @brand = brand
    mail(to: @user.email, subject: "your partnered brand subscription was successfully updated.")
  end

end
