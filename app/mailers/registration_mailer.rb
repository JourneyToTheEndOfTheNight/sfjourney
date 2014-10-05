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
      attachments.inline['qr.png'] = {
        :data => Base64.encode64(registration.qr_code_data),
        :mime_type => "image/png",
        :encoding => "base64"
      }
      @qr_inline = attachments['qr.png'].url
    rescue => e
      logger.error "Error attaching QR code: " + e.to_s + e.backtrace.join("\n")
    end
    mail(:to => @registration.email,
         :subject => "Journey ticket: PRINT and BRING TO START LINE")
  end
end