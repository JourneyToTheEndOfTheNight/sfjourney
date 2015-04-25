require 'google/api_client'

# Only used in development, to get a Google Auth secret for creating metadata/results google docs for experiments
class GoogleAuthController < ApplicationController
  def auth
    redirect_url = request.original_url.gsub("google_auth", "google_redirect").gsub(/\?.*$/, "")
    Rails.logger.info("Redirecting to #{redirect_url}")

    client = Google::APIClient.new(:application_name => "Discretion", :application_version => "0.1")
    client.authorization.client_id = '1030837965191-e067plds3k2apn4n328mme9ppqg32r6s.apps.googleusercontent.com'
    client.authorization.client_secret = 'aPu31RLsNhJQF7sCCw2HD5EN'
    client.authorization.redirect_uri = redirect_url

    client.authorization.scope = ['https://www.googleapis.com/auth/calendar']

    Rails.logger.info(client.authorization.inspect)
    Rails.logger.info(client.authorization.authorization_uri.inspect)
    Rails.logger.info(client.authorization.authorization_uri.to_s)

    redirect_to client.authorization.authorization_uri.to_s
  end

  def receive_redirect
    authorization_code = params["code"]

    client = Google::APIClient.new(:application_name => "Discretion", :application_version => "0.1")
    client.authorization.client_id = '1030837965191-e067plds3k2apn4n328mme9ppqg32r6s.apps.googleusercontent.com'
    client.authorization.client_secret = 'aPu31RLsNhJQF7sCCw2HD5EN'
    client.authorization.redirect_uri = request.original_url.gsub(/\?.*$/, "")
    Rails.logger.info("Maybe it's okay to use #{client.authorization.redirect_uri}?")
    client.authorization.code = authorization_code

    result = client.authorization.fetch_access_token!
    Rails.logger.info(result.inspect)
    render :json => result.to_json
  end

end
