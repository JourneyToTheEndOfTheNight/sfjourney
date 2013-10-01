class UsersController < ApplicationController
  before_filter :authenticate_user!, :except => [:index]

private
  def user_params
    params.require(:user).permit(:name, :email)
  end
end
