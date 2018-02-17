class AthletesController < ApplicationController
  before_action :authenticate_user!, :ensure_authorization_token!

  def index
    athlete = Athlete.current(strava_client)
    render json: AthleteSerializer.new(athlete)
  end

  def show
    athlete = Athlete.find(strava_client, params[:id])
    render json: AthleteSerializer.new(athlete)
  end
end
