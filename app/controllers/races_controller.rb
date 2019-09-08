class RacesController < ApplicationController
  before_action :authenticate_user!, :ensure_authorization_token!

  def index
    render json: Race.all
  end

  def splits
    require_params(:id, :year)
    date = RaceEvent.where(race_id: params[:id], year: params[:year]).pluck(:occured_at).last

    activities = Activity.within_date_range(strava_client, date: date.to_time, sanitize_threshold: 15)
    render json: ActiveModel::ArraySerializer.new(activities, each_serializer: BaseActivitySerializer)
  end

  def efforts
    require_params(:id)
    occurances = RaceEvent.where(race_id: params[:id]).pluck(:year, :occured_at).to_h
    efforts = {}
    occurances.each do |year, date|
      activities = Activity.within_date_range(strava_client, date: date.to_time, sanitize_threshold: 15)
      efforts[year] = ActiveModel::ArraySerializer.new(activities, each_serializer: EffortSerializer).as_json
    end

    render json: efforts
  end

  def preparation
    require_params(:id)
    occurances = RaceEvent.where(race_id: params[:id]).pluck(:year, :occured_at).to_h
    preparation = {}
    preparation_period = (params[:preparation_period] || 4).to_i.months
    occurances.each do |year, date|
      activities = Activity.within_date_range(strava_client, before: date.to_time.to_i, after: (date.to_time - preparation_period).to_i, sanitize: true)
      next unless activities.present?

      preparation[year] = PreparationAnalyzer.new(activities).analyze
    end

    render json: preparation
  end

private
  def strava_client
    @strava_client ||= StravaClient.new(access_token: current_user.authorization_token)
  end
end
