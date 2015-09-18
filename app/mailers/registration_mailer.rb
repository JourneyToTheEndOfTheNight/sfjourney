class RegistrationMailer < ActionMailer::Base
  default :from => "Journey To The End Of The Night <#{ENV['GMAIL_EMAIL']}>"

  def new_registration_email(registration)
    @registration = registration
    @num_registered = registration.game.registrations.count
    mail(:to => ENV['GMAIL_EMAIL'],
         :subject => "[journeyreg] #{@registration.name}/#{@registration.team_name}; #{@num_registered} registered")
  end

  def confirmation_email(registration)
    @registration = registration
    begin
      attachments['journey_waiver.pdf'] = File.read(@registration.waiver_file)
    rescue => e
      logger.error "Error attaching waiver for #{registration.inspect}: " + e.to_s + e.backtrace.join("\n")
    end
    mail(:to => @registration.email,
         :subject => "Journey ticket: PRINT and BRING TO START LINE")
  end
end