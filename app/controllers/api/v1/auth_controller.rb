class Api::V1::AuthController < ApplicationController
  def login
    @current_user = User.find_by_email(params[:email])
    if @current_user && @current_user.authenticate(params[:password])
      @token = JwtToken.encode(user_id: @current_user.id)
      @time = Time.now + 24.hours.to_i
    else
      render json: { error: 'unauthorized' }, status: :unauthorized
    end
  end

  private

  def login_params
    params.permit(:email, :password)
  end
end
