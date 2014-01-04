class RegistrationsController < ApplicationController
  before_filter :authenticate_user!, :except => [:landing]
  before_action :set_registration, only: [:show, :edit, :update, :destroy]
  before_action :require_admin!, only: [:export]

  def landing
    @num_remaining = Registration.display_num_remaining

    if user_signed_in?
      redirect_to '/registrations'
    end
  end

  # registrations are full
  def full
  end

  def blank_waiver
    if !is_admin?
      redirect_to "/registrations"
    end
    @underage = params[:underage]
  end

  def verify
    @registration = Registration.find_by_id(params[:id])
    #@qr = @registration.qr_code
    if is_admin?
      @registration.checked_in = true;
      @registration.save!
    end
    redirect_to "/registrations/#{@registration.id}"
  end

  def export
    if params[:reg_email]
      @registrations = Registration.all.uniq {|u| u.email}
      csv_string = "\"name\",\"email\"\n"
      @registrations.each do |u|
        csv_string += "\"#{u.name}\",\"#{u.email}\"\n"
      end
    elsif params[:all_fields]
      @registrations = Registration.all
      csv_string = "\"user_id\",\"id\",\"name\",\"email\",\"team_name\",\"age\",\"birthday\",\"signup_timestamp\",\"address\",\"city\",\"state\",\"zip\",\"phone\"\n"
      @registrations.each do |u|
        csv_string += "#{u.user_id},#{u.id},\"#{u.name}\",\"#{u.email}\",\"#{u.team_name}\",#{u.age if u.birthday},#{u.birthday},#{u.created_at.to_i},\"#{u.address}\",\"#{u.city}\",\"#{u.state}\",\"#{u.zip}\",\"#{u.phone}\"\n"
      end
    else
      @registrations = Registration.where('can_email', true).uniq#group(:email)
      csv_string = "\"name\",\"email\"\n"
      @registrations.each do |u|
        csv_string += "\"#{u.name}\",\"#{u.email}\"\n"
      end
    end
    send_data csv_string, :type => 'text/csv; charset=iso-8859-1; header=present', :disposition => "attachment; filename=emails.csv"
  end

  # GET /registrations
  # GET /registrations.json
  def index
    @registrations = current_user.registrations
    if @registrations.length <= 0
      redirect_to '/registrations/new'
    end
  end

  # GET /registrations/1
  # GET /registrations/1.json
  def show
    if @registration.user != current_user
      redirect_to '/registrations'
    end
    @qr = @registration.qr_code
  end

  # GET /registrations/new
  def new
    if Registration.num_remaining <= 0 && !current_user.friend_space?
      redirect_to '/registrations/full'
    end
    @registration = Registration.new(:name => current_user.name,
                                     :email => current_user.email,
                                     :can_email => true)
  end

  # POST /registrations
  # POST /registrations.json
  def create
    if Registration.num_remaining <= 0 && !current_user.friend_space?
      redirect_to '/registrations/full'
    end
    @registration = Registration.new(registration_params)
    @registration.user = current_user

    respond_to do |format|
      if @registration.save
        format.html do
          begin
            RegistrationMailer.confirmation_email(@registration).deliver
            RegistrationMailer.new_registration_email(@registration).deliver
          rescue => e
            logger.error "Error sending email" + e.to_s + e.backtrace.join("\n")
          end
          redirect_to @registration, notice: 'Registration was successfully created.'
        end
        format.json { render action: 'show', status: :created, location: @registration }
      else
        format.html { render action: 'new' }
        format.json { render json: @registration.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /registrations/1
  # DELETE /registrations/1.json
  def destroy
    if @registration.user != current_user
      redirect_to '/registrations'
    end
    @registration.destroy
    respond_to do |format|
      format.html { redirect_to registrations_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_registration
      @registration = Registration.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def registration_params
      params.require(:registration).permit(:name, :email, :can_email,
        :team_name, :birthday,
        :address, :city, :state, :zip, :phone)
    end
end
