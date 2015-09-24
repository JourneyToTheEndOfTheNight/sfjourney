#    require 'securerandom'
class Registration < ActiveRecord::Base
  belongs_to :user
  belongs_to :game
  validates_presence_of :name, :email, :birthday,
    :address, :city, :state, :zip, :phone
  validates_format_of :email, :with => /\A([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})\z/i
  before_create :add_token

  def add_token
    begin
      new_token = SecureRandom.hex.upcase[0..5].gsub('O','0').gsub(/IL/,'1').gsub(/S/,'5').gsub(/B/,'8')
    end while Registration.find_by_token(new_token) != nil
    self.token = new_token
  end

  def has_duplicate
    # TODO: look for similar
  end

  def equals(registration)
    self.game_id == registration.game_id &&
    self.name == registration.name &&
    self.email == registration.email &&
    self.birthday == registration.birthday
  end

  def underage?
    birthday + 18.years > game.starts_at
  end

  def age
    ((game.starts_at.to_date - birthday)/365.0).to_i
  end

  def qr_code
    begin
      return "<img src='data:image/png;base64,#{Base64.encode64(qr_code_data)}' />".html_safe
    rescue => e
      logger.error "Error encoding: " + e.to_s + e.backtrace.join("\n")
    end
  end

  def qr_file
    "./tmp/qr_#{self.id}.png"
  end

  def qr_code_data
    begin
      if not File.exist?(qr_file)
        Qr4r::encode("http://sfjourney.herokuapp.com/r/#{self.game_id}/#{self.token}", qr_file)
      end
      return File.read(qr_file)
    rescue => e
      logger.error "Error with qr file: " + e.to_s + e.backtrace.join("\n")
    end
    return nil
  end

  def waiver_file
    filename = "./tmp/waiver_#{self.id}.pdf"
    if not File.exist?(filename)
      namespace = OpenStruct.new(:registration => self)
      template = ERB.new(File.open(Rails.root.join('app','views','registration_mailer','_waiver.html.erb')).read)
      filled_waiver = template.result(namespace.instance_eval { binding })
      pdf = WickedPdf.new.pdf_from_string(filled_waiver, :margin => {:top                => 0.5,
                           :bottom             => 0,
                           :left               => 0.5,
                           :right              => 0.5})
      File.open(filename, 'wb') do |file|
        file << pdf
      end
      #system("open #{waiver_file}")
    end
    filename
  end
end
