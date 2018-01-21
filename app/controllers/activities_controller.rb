class ActivitiesController < ApplicationController
  before_action :authenticate_user!, :ensure_strava_token!

  def index
    render json: { current_user: current_user }
  end

  def show
    render json: params
  end

  def ensure_strava_token!
    unless current_user.strava_token
      client_id = Rails.application.secrets.strava_client_id
      # redirect_uri = 'https%3A%2F%2Fvast-depths-34461.herokuapp.com%2Fauth%2Fexchange'
      # TODO: set https
      redirect_uri = 'localhost%3A3000%2Fauth%2Fexchange'

      redirect_to "https://www.strava.com/oauth/authorize?client_id=#{client_id}&redirect_uri=#{redirect_uri}&response_type=code&scope=view_private"
    end
  end
end
