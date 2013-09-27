class User < ActiveRecord::Base
  has_many :services
  has_many :registrations

private
  def user_params
    params.require(:user).permit(:name, :email)
  end
end

