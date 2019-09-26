class WebhooksController < ActionController::API
  # before_action :authorize_request!
  rescue_from Strava::Api::V3::ClientError, with: :failed_event

  def hook
    if new_activity?
      Strava::ActivityImporter.new(strava_client, params[:object_id]).perform
      Strava::ActivityDescriber.new(strava_client, params[:object_id]).perform
    end

    if delete_activity?
      Activity.where(external_id: params[:object_id]).delete_all
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

  def delete_activity?
    params[:aspect_type] == 'delete' && params[:object_type] == 'activity'
  end

  # def authorize_request!
  #   raise 'mismatch verification token' unless params[:verification_token] == Rails.application.secrets.strava_webhook_verification_code
  # end

  def failed_event
    failed_event_fields = %i[aspect_type object_type object_id owner_id]
    FailedEvent.create!(params.slice(*failed_event_fields))
  end

  def strava_client
    @strava_client ||= begin
      access_token = User.where(uid: params[:owner_id]).pluck(:authorization_token)
      return unless access_token

      Strava::Client.new(access_token: access_token)
    end
  end
end
