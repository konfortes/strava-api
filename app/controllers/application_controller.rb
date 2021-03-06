class ApplicationController < ActionController::API
  def require_params(*keys)
    keys.each_with_object(params) do |key, obj|
      obj.require(key)
    end
  end

  def ensure_authorization_token!
    raise 'missing authorization token' unless current_user&.authorization_token
  end

  def strava_client
    @strava_client ||= Strava::Client.new(access_token: current_user.fresh_authorization_token)
  end
end
