class RegistrationMailer < ActionMailer::Base
  default :from => "Journey To The End Of The Night <#{ENV['GMAIL_EMAIL']}>"

  def confirmation_email(registration)
    @registration = registration
    mail(:to => @registration.email, :subject => "Journey ticket: PRINT and BRING TO START LINE")
  end
end