class ContactMailer < ApplicationMailer

  def contact_form(email, contact)
    @email = email
    @contact = contact

    mail(to: @email, subject: "#{@contact.name} sent you a message from - 2Dots Properties")
  end

end
