class RegistrationMailer < ActionMailer::Base
  default :from => "Journey To The End Of The Night <#{ENV['GMAIL_EMAIL']}>"

  def new_registration_email(registration)
    @registration = registration
    @num_remaining = Registration.num_remaining
    mail(:to => ENV['GMAIL_EMAIL'],
         :subject => "[journeyreg] #{@registration.name}/#{@registration.team_name}; #{Registration.num_remaining} left")
  end

  def confirmation_email(registration)
    @registration = registration
    mail(:to => @registration.email,
         :subject => "Journey ticket: PRINT and BRING TO START LINE")
  end
end