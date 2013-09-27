json.array!(@registrations) do |registration|
  json.extract! registration, :user_id, :name, :email, :can_email, :emergency_contact_name, :emergency_contact_phone, :emergency_contact_relationship, :birthday, :address, :city, :state, :zip, :phone
  json.url registration_url(registration, format: :json)
end
