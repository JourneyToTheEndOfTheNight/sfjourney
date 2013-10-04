class Registration < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :name, :email, :can_email, :birthday,
    :address, :city, :state, :zip, :phone
  validates_format_of :email, :with => /\A([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})\z/i

  def self.max_registrations
    2400
  end

  def self.num_remaining
    self.max_registrations - Registration.count
  end

  def underage?
    birthday + 18.years > Date.new(2013, 11, 9)
  end

  def qr_code
    begin
      qr_file = "./tmp/qr_#{self.id}.png"
      if not File.exist?(qr_file)
        Qr4r::encode("http://sfjourney.herokuapp.com/r/#{self.id}", qr_file)
      end
      return File.read(qr_file)
    rescue => e
    end
    return nil
  end

end
