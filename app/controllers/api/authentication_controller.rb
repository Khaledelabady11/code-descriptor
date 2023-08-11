module Api
  class AuthenticationController < ApplicationController
    before_action :authorize_request, only: [:logout]
    skip_before_action :verify_authenticity_token


    def login
      @user = User.find_by_email(params[:email])
      if @user&.authenticate(params[:password])
        token = JsonWebToken.encode(user_id: @user.id)
        @user.update(token: token)
        render 'api/authentication/login', formats: :json
      else
        render json: { error: 'unauthorized' }, status: :unauthorized
      end
    end


    def logout
      @current_user.update(token: nil)
      render json: { message: 'Logout successful' }, status: :ok
    end


    private

    def login_params
      params.permit(:email, :password)
    end
  end
end

