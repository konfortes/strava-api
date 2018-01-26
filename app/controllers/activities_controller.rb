class ActivitiesController < ApplicationController
  before_action :authenticate_user!, :ensure_authorization_token!

  SANITIZE_THRESHOLD = 1500

  ISRAMAN_DATES = {
    2013 => '25-01-2013',
    2014 => '17-01-2014',
    2015 => '29-01-2015',
    2016 => '29-01-2016',
    2017 => '27-01-2017',
    2018 => '26-01-2018'
  }

  def index
    activities = client.list_athlete_activities(params.permit(:before, :after))
    activities.map! { |activity| Activity.new(activity) }

    render json: ActiveModel::ArraySerializer.new(activities, each_serializer: BaseActivitySerializer)
  end

  def show
    activity = client.retrieve_an_activity(params[:id])
    render json: ActivitySerializer.new(Activity.new(activity))
  end

  def israman_splits
    params.require(:year)
    date = ISRAMAN_DATES[params[:year].to_i]
    activities = list_athlete_activities(date, sanitize: true)

    render json: ActiveModel::ArraySerializer.new(activities, each_serializer: BaseActivitySerializer)
  end

  def israman_efforts
    efforts = {}
    ISRAMAN_DATES.each do |year, date|
      activities = list_athlete_activities(date, sanitize: true)
      efforts[year] = ActiveModel::ArraySerializer.new(activities, each_serializer: EffortSerializer).as_json
    end

    render json: efforts
  end

  private

    def list_athlete_activities(date, options = {})
      range = activities_range(date)

      activities = client.list_athlete_activities(range)
      sanitize_activities!(activities) if options[:sanitize]
      activities.map { |activity| Activity.new(activity) }
    end

    def activities_range(date)
      date = DateTime.strptime(date, '%d-%m-%Y')
      { before: date.to_i + 1.days, after: date.to_i - 1.days }
    end

    def sanitize_activities!(activities)
      activities.select! { |activity| activity['elapsed_time'] > SANITIZE_THRESHOLD }
    end

    def ensure_authorization_token!
      unless current_user && current_user.authorization_token
        raise 'missing authorization token'
      end
    end

    def client
      @client ||= Strava::Api::V3::Client.new(access_token: current_user.authorization_token)
    end
end
