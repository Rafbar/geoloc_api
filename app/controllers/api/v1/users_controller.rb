class Api::V1::UsersController < ApplicationController
  before_action :authorize_user, except: :create
  before_action :validate_current_user, except: :create

  def show
  end

  def create
    @current_user = User.new(user_params)
    if @current_user.save
      render :show
    else
      render_unprocessable
    end
  end

  def update
    if @current_user.update_attributes(user_params)
      render :show
    else
      render_unprocessable
    end
  end

  def destroy
    if @current_user.destroy
      render json: {}, status: 200
    else
      render_unprocessable
    end
  end

  private

  def validate_current_user
    render json: {}, status: :unauthorized unless params[:id].to_i == @current_user.id
  end

  def user_params
    params.permit(:name, :username, :email, :password, :password_confirmation)
  end

  def render_unprocessable
    render json: {user: @current_user.errors}, status: :unprocessable_entity
  end
end
