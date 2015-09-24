class RegistrationsController < ApplicationController
  before_filter :authenticate_user!, :except => [:landing]
  before_action :set_registration, only: [:show, :edit, :update, :destroy]
  before_action :require_admin!, only: [:export]

  def landing
    @num_remaining = current_game.display_num_remaining

    if user_signed_in?
      redirect_to '/registrations'
    end
  end

  # registrations are full
  def full
    false
    # current_game.num_remaining <= 0 && !current_user.friend_space?(current_game)
  end

  def verify
    @registration = Registration.find(:game_id => params[:game_id], :token => params[:registration_token])
    if is_admin?
      @registration.checked_in = true;
      @registration.save!
    end
    redirect_to "/registrations/#{@registration.id}"
  end

  def export
    if params[:reg_email]
      @registrations = current_game.registrations.uniq {|u| u.email}
      csv_string = "\"name\",\"email\"\n"
      @registrations.each do |u|
        csv_string += "\"#{u.name}\",\"#{u.email}\"\n"
      end
    elsif params[:all_fields]
      @registrations = current_game.registrations.includes(user: [:services])
      csv_string = "\"user_id\",\"id\",\"service_min_ts\",\"service_max_ts\",\"services\",\"name\",\"email\",\"team_name\",\"age\",\"birthday\",\"signup_timestamp\",\"address\",\"city\",\"state\",\"zip\",\"phone\",\"user_agent\",\"ip_address\",\"referrer\"\n"
      @registrations.each do |u|
        csv_string += "#{u.user_id},#{u.id},\"#{u.user.services.map {|s| s.created_at}.min.to_i}\",\"#{u.user.services.map {|s| s.created_at}.max.to_i}\",\"#{u.user.services.map {|s| s.provider}.join(";")}\",\"#{u.name}\",\"#{u.email}\",\"#{u.team_name}\",#{u.age if u.birthday},#{u.birthday},#{u.created_at.to_i},\"#{u.address}\",\"#{u.city}\",\"#{u.state}\",\"#{u.zip}\",\"#{u.phone}\",\"#{u.user_agent}\",\"#{u.ip_address}\",\"#{u.referrer}\"\n"
      end
    else
      @registrations = current_game.registrations.where('can_email', true).uniq#group(:email)
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
    @registrations = current_user.registrations_for(current_game)
    if @registrations.length <= 0
      redirect_to '/registrations/new'
    end
  end

  # GET /registrations/1
  # GET /registrations/1.json
  def show
    if @registration.user != current_user && !is_admin?
      redirect_to '/registrations'
    end
    send_file(@registration.waiver_file, filename: 'journey_waiver.pdf', type: 'application/pdf', disposition: :inline)
  end

  def edit
    if @registration.user != current_user && !is_admin?
      redirect_to '/registrations'
    end
    @qr = @registration.qr_code
  end

  # GET /registrations/new
  def new
    registrations = current_user.registrations_for(current_game)
    if registrations.length > 0 && !is_admin?
      redirect_to '/registrations'
    end
    if full
      redirect_to '/registrations/full'
    end
    @registration = Registration.new(:name => current_user.name,
                                     :email => current_user.email,
                                     :can_email => true)
  end

  # POST /registrations
  # POST /registrations.json
  def create
    if full
      redirect_to '/registrations/full'
    end
    @registration = Registration.new(registration_params)
    @registration.game = current_game
    @registration.user = current_user
    @registration.ip_address = request.remote_ip
    @registration.user_agent = request.user_agent
    @registration.referrer = cookies[:referrer]

    respond_to do |format|
      if @registration.save
        format.html do
          begin
            RegistrationMailer.confirmation_email(@registration).deliver
            if @registration.game.registrations.length % 100 == 0
              RegistrationMailer.new_registration_email(@registration).deliver
            end
          rescue => e
            logger.error "Error sending email" + e.to_s + e.backtrace.join("\n")
          end
          redirect_to '/registrations', notice: 'Registration was successfully created.'
          # redirect_to @registration, notice: 'Registration was successfully created.'
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

  def graph
    ts = current_game.registrations.pluck(:created_at).map {|t| t.to_i}.sort
    @data = ts.each_with_index.map {|ts, i| {'ts' => ts * 1000, 'timestr' => Time.at(ts).strftime("%m/%d %H:%M:%S"), 'registered' => i}}
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
