class ApplicationController < ActionController::API
  include ActionController::Helpers
  include ActionController::Caching

  def not_found
    render json: { error: 'not_found' }
  end

  # This is obviously an unsafe autorization method for production considering it uses
  # only incremental id and Secret for creating the tokens.

  def authorize_user
    header = request.headers['Authorization']
    header = header.split(' ').last if header
    begin
      @decoded = JwtHelper.decode(header)
      @current_user = User.find(@decoded[:user_id])
    rescue ActiveRecord::RecordNotFound => e
      render json: { errors: e.message }, status: :unauthorized
    rescue JWT::DecodeError => e
      render json: { errors: e.message }, status: :unauthorized
    end
  end
end
