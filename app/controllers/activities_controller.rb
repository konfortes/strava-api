class ActivitiesController < ApplicationController
  before_action :authenticate_user!, :ensure_authorization_token!

  def index
    render json: client.list_athlete_activities(before: params[:before], after: params[:after])
  end

  def show
    render json: client.retrieve_an_activity(params[:id])
  end

  def israman_splits
    israman_dates = {
      2013 => '25-01-13',
      2014 => '',
      2016 => '',
      2017 => ''
    }
  end

  private
    def ensure_authorization_token!
      unless current_user && current_user.authorization_token
        raise 'missing authorization token'
      end
    end

    def client
      @client ||= Strava::Api::V3::Client.new(access_token: current_user.authorization_token)
    end
end
