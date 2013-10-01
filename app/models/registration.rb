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

private
  def registration_params
    params.require(:registration).permit(:name, :email, :can_email, :birthday,
      :address, :city, :state, :zip, :phone)
  end
end
