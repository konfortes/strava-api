class User < ApplicationRecord
  has_many :activities, foreign_key: :athlete_id
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:strava]

  def self.from_omniauth(auth)
    persisted_user = where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.email = auth.info.email || "no_email#{Time.current.to_i}@stam.com"
      user.password = Devise.friendly_token[0, 20]
      # TODO: rename to access_token
      user.authorization_token = auth.credentials.token
      user.refresh_token = auth.credentials.refresh_token
      user.auth_token_expires_at = auth.credentials.expires_at
    end

    # HACK: for users that were already created without refresh token
    if persisted_user.refresh_token.blank?
      persisted_user.update!(refresh_token: auth.credentials.refresh_token)
    end

    persisted_user.reload
  end

  def fresh_authorization_token
    return authorization_token if auth_token_expires_at && auth_token_expires_at > Time.current.to_i

    refresh_token!
  end

  private

  def refresh_token!
    url = 'https://www.strava.com/oauth/token'
    params = {
      client_id: Rails.application.secrets.strava_client_id,
      client_secret: Rails.application.secrets.strava_api_key,
      grant_type: 'refresh_token',
      refresh_token: refresh_token
    }

    response = Faraday.post(url, params)
    raise "unable to refresh token for user ##{id}" unless response.status == 200

    response = JSON(response.body).with_indifferent_access

    update!(authorization_token: response[:access_token],
            refresh_token: response[:refresh_token],
            auth_token_expires_at: response[:expires_at])

    response[:access_token]
  end
end
