# frozen_string_literal: true

class WebhooksController < ActionController::API
  # before_action :authorize_request!

  def hook
    if new_activity?
      Strava::ActivityImporter.new(strava_client, params[:object_id]).perform
      Strava::ActivityDescriber.new(strava_client, params[:object_id]).perform
    end

    head :ok
  end

  def verify
    render json: { 'hub.challenge' => params['hub.challenge'] }
  end

  private

  def new_activity?
    params[:aspect_type] == 'create' && params[:object_type] == 'activity'
  end

  # def authorize_request!
  #   raise 'mismatch verification token' unless params[:verification_token] == Rails.application.secrets.strava_webhook_verification_code
  # end

  def strava_client
    @strava_client ||= begin
      access_token = User.where(uid: params[:owner_id]).first
      Strava::Client.new(access_token: access_token)
    end
  end
end
