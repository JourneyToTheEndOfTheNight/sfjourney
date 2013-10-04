class RegistrationMailer < ActionMailer::Base
  default :from => "Journey To The End Of The Night <#{ENV['GMAIL_EMAIL']}>"

  def new_registration_email(registration)
    @registration = registration
    @num_remaining = Registration.num_remaining
    @num_with_same_email = Registration.where(:email => registration.email).count
    @num_with_same_team = Registration.where(:team_name => registration.team_name).count
    mail(:to => ENV['GMAIL_EMAIL'],
         :subject => "[journeyreg] #{@registration.name}/#{@registration.team_name}; #{Registration.num_remaining} left")
  end

  def confirmation_email(registration)
    @registration = registration
    begin
      attachments.inline['qr.png'] = {
        :data => File.read(registration.qr_file),
        :mime_type => "image/png",
        :encoding => "base64"
      }
      @qr_inline = 'qr.png'
    rescue => e
      logger.error "Error attaching QR code: " + e + e.backtrace.join("\n")
    end
    mail(:to => @registration.email,
         :subject => "Journey ticket: PRINT and BRING TO START LINE")
  end
end