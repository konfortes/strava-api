class ActivitiesController < ApplicationController
  before_action :authenticate_user!, :ensure_authorization_token!

  def index
    activities = client.list_athlete_activities(params.permit(:before, :after))
    activities.map! { |activity| Activity.new(activity) }

    render json: ActiveModel::ArraySerializer.new(activities, serializer: BaseActivitySerializer)
  end

  def show
    activity = client.retrieve_an_activity(params[:id])
    render json: ActivitySerializer.new(Activity.new(activity))
  end

  def israman_splits
    params.require(:year)
    israman_dates = {
      2013 => '25-01-2013',
      2014 => '17-01-2014',
      2015 => '29-01-2015',
      2016 => '29-01-2016',
      2017 => '27-01-2017',
      2018 => '26-01-2018'
    }

    year = params[:year].to_i
    israman_date = DateTime.strptime(israman_dates[year], '%d-%m-%Y')

    activities = client.list_athlete_activities(before: israman_date.to_i + 1.days, after: israman_date.to_i - 1.days)
    activities.map! { |activity| Activity.new(activity) }

    render json: ActiveModel::ArraySerializer.new(activities, serializer: BaseActivitySerializer)
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
