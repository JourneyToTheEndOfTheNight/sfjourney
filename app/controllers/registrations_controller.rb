class RegistrationsController < ApplicationController
  before_filter :authenticate_user!, :except => [:landing]
  before_action :set_registration, only: [:show, :edit, :update, :destroy]
  before_action :require_admin!, only: [:export]

  def landing
    @num_remaining = Registration.num_remaining

    if user_signed_in?
      redirect_to '/registrations'
    end
  end

  def full
  end

  def export
    @registrations = Registration.where('can_email', true).uniq#group(:email)
    if params[:all_fields]
      csv_string = "\"name\",\"email\",\"birthday\",\"address\",\"city\",\"state\",\"zip\",\"phone\"\n"
      @registrations.each do |u|
        csv_string += "\"#{u.name}\",\"#{u.email}\",\"#{u.birthday.strftime("%m/%d/%Y") if u.birthday}\",\"#{u.address}\",\"#{u.city}\",\"#{u.state}\",\"#{u.zip}\",\"#{u.phone}\"\n"
      end
    else
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
    if @registrations.length == 0
      redirect_to '/registrations/new'
    end
  end

  # GET /registrations/1
  # GET /registrations/1.json
  def show
  end

  # GET /registrations/new
  def new
    if Registration.num_remaining <= 0
      redirect_to '/registrations/full'
    end
    @registration = Registration.new(:name => current_user.name,
                                     :email => current_user.email,
                                     :can_email => true)
  end

  # POST /registrations
  # POST /registrations.json
  def create
    if Registration.num_remaining <= 0
      redirect_to '/registrations/full'
    end
    @registration = Registration.new(registration_params)
    @registration.user = current_user

    respond_to do |format|
      if @registration.save
        format.html do
          begin
            RegistrationMailer.confirmation_email(@registration).deliver
          rescue Exception => e
            logger.error e.backtrace
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
      params.require(:registration).permit(:name, :email, :can_email, :emergency_contact_name, :emergency_contact_phone, :emergency_contact_relationship, :birthday, :address, :city, :state, :zip, :phone)
    end
end
