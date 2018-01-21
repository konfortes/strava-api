class ActivitiesController < ApplicationController
  before_action :authenticate_user!

  def index
    render json: { current_user: current_user }
  end

  def show
    render json: params
  end
end
