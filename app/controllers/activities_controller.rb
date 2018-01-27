class ActivitiesController < ApplicationController
  before_action :authenticate_user!, :ensure_authorization_token!

  SANITIZE_THRESHOLD = 1500

  ISRAMAN_DATES = {
    2013 => DateTime.strptime('25-01-2013', '%d-%m-%Y'),
    2014 => DateTime.strptime('17-01-2014', '%d-%m-%Y'),
    2015 => DateTime.strptime('29-01-2015', '%d-%m-%Y'),
    2016 => DateTime.strptime('29-01-2016', '%d-%m-%Y'),
    2017 => DateTime.strptime('27-01-2017', '%d-%m-%Y'),
    2018 => DateTime.strptime('26-01-2018', '%d-%m-%Y')
  }

  def index
    activities = list_athlete_activities(params.permit(:before, :after))
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
    activities = list_athlete_activities(date: date, sanitize: true)

    render json: ActiveModel::ArraySerializer.new(activities, each_serializer: BaseActivitySerializer)
  end

  def israman_efforts
    efforts = {}
    ISRAMAN_DATES.each do |year, date|
      activities = list_athlete_activities(date: date, sanitize: true)
      efforts[year] = ActiveModel::ArraySerializer.new(activities, each_serializer: EffortSerializer).as_json
    end

    render json: efforts
  end

  def israman_preparation
    preparation = {}
    preparation_period = (params[:preparation_period] || 4).months
    ISRAMAN_DATES.each do |year, date|
      activities = list_athlete_activities(before: date.to_i, after: (date - preparation_period).to_i, sanitize: true)
      next unless activities.present?
      preparation[year] = PreparationAnalyzer.new(activities).analyze
    end

    render json: preparation
  end

  def auto_generate_description
    params.require(:id)
    activity = client.retrieve_an_activity(params[:id])
    render :not_found and return unless activity

    activity = Activity.new(activity)
    description = LapsDescriptor.new(activity).describe

    client.update_an_activity(activity.id, description: description)

    head :ok
  end

  def most_kudosed
    year = params[:year] || DateTime.now.year
    beginning_of_year = DateTime.parse("01-01-#{year}")
    range = {before: (DateTime.now + 1.days).to_i, after: (beginning_of_year - 1.days).to_i }

    activities = list_athlete_activities(range)
    activity = activities.max { |a1, a2| a1.kudos_count <=> a2.kudos_count }

    render json: BaseActivitySerializer.new(activity)
  end

  private
    def list_athlete_activities(options = {})
      range = options.has_key?(:date) ? day_range(options[:date]) : options.slice(:before, :after)

      activities = client.list_athlete_activities(range)
      sanitize_activities!(activities) if options[:sanitize]
      activities.map { |activity| Activity.new(activity) }
    end

    def day_range(date)
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
