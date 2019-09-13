# frozen_string_literal: true

class User < ApplicationRecord
  has_many :activities, foreign_key: :athlete_id
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:strava]

  def self.from_omniauth(auth)
    existing_user = where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.email = auth.info.email || "no_email#{Time.current.to_i}@stam.com"
      user.password = Devise.friendly_token[0, 20]
      user.authorization_token = auth.credentials.token
    end

    if existing_user.authorization_token != auth.credentials.token
      existing_user.authorization_token = auth.credentials.token
      existing_user.save!
    end

    existing_user
  end
end
