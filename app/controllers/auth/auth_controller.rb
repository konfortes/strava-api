class Auth::AuthController < ApplicationController
  before_action :authenticate_user!

  def exchange
    args = {
      client_id: Rails.application.secrets.strava_client_id,
      client_secret: Rails.application.secrets.strava_api_key,
      code: params[:code]
    }
    access_information =
      HTTMultiParty.public_send(
        'post',
        'https://www.strava.com/oauth/token',
        query: args
      )
    render json: { error: 'unable to get access information' } and return unless access_information['access_token'].present?
    # TODO: set the code on current_user
    render json: access_information
  end
end
