class ActivitiesController < ApplicationController
  before_action :authenticate_user!, :ensure_authorization_token!

  def index
    range = params.permit(:before, :after).reverse_merge(after: 7.days.ago.to_i, before: 1.days.from_now.to_i)
    activities = Activity.within_date_range(strava_client, range)

    render json: ActiveModel::ArraySerializer.new(activities, each_serializer: BaseActivitySerializer)
  end

  def show
    activity = Activity.find(strava_client, params[:id])
    render json: ActivitySerializer.new(activity)
  end

  def auto_generate_description
    require_params(:id)
    activity = Activity.find(strava_client, params[:id])
    render :not_found and return unless activity

    description = LapsDescriptor.new(activity).describe
    Activity.update(strava_client, params[:id], description: description) if description

    head :ok
  end

  def most_kudosed
    year = params[:year] || DateTime.now.year
    beginning_of_year = DateTime.parse("01-01-#{year}")
    range = { before: (DateTime.now + 1.days).to_i, after: (beginning_of_year - 1.days).to_i }

    activities = Activity.within_date_range(strava_client, range)
    activity = activities.max { |a1, a2| a1.kudos_count <=> a2.kudos_count }

    render json: BaseActivitySerializer.new(activity)
  end
end
