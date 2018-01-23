class ActivitiesController < ApplicationController
  before_action :authenticate_user!, :ensure_authorization_token!

  def index
    render json: { current_user: current_user }
  end

  def show
    render json: params
  end

  def ensure_authorization_token!
    unless current_user && current_user.authorization_token
      raise 'missing authorization token'
    end
  end
end
