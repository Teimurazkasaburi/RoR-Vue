class UserMailer < ApplicationMailer
  def iforgot(user, temp_password)
    @user = user
    @temp_password = temp_password
    mail(to: @user.email, subject: '2Dots Properties - Password Reset')
  end


  def welcome(user)
    @user = user
    mail(to: @user.email, subject: 'Welcome To 2Dots Properties!')
  end
end
