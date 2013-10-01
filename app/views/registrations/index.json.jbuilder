json.array!(@registrations) do |registration|
  json.extract! registration, :user_id, :name, :email, :can_email, :team_name,
  :birthday, :address, :city, :state, :zip, :phone
  json.url registration_url(registration, format: :json)
end
