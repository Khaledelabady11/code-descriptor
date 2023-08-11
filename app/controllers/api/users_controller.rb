module Api
  class UsersController < ApplicationController
    before_action :authorize_request, only: [:update, :destory]
    before_action :find_user ,only: [:edit,:show ,:destroy]
    skip_before_action :verify_authenticity_token


    def index
      @users = User.all
      render 'api/users/index', formats: :json

    end

    def show
      render 'api/users/show', formats: :json
    end

    def create
      @user = User.new(user_params)
      if @user.save
        if params[:user][:avatar].present?
          response = ImgurUploader.upload(params[:user][:avatar].tempfile.path)
          create_avatar_for_user(@user, response)
          token = JsonWebToken.encode(user_id: @user.id)
          @user.update(token: token)
          render 'api/users/create', formats: :json
        end
      else
        render json: { errors: @user.errors.full_messages },
               status: :unprocessable_entity
      end
    end

    def update
      unless @user.update(user_params)
        render json: { errors: @user.errors.full_messages },
               status: :unprocessable_entity
      end
    end

    def destroy
      @user.destroy
    end

    private

    def find_user
      begin
        @user = User.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { errors: 'User not found' }, status: :not_found
      rescue => e
        render json: { errors: e.message }, status: :unprocessable_entity
      end
    end

    def user_params
      params.require(:user).permit(
        :name, :username, :email, :password, :password_confirmation,
        user: [:avatar]
      )
    end



    def create_avatar_for_user(content, response)
      resource_id = response['data']['id']
      resource_type = response['data']['type']
      resource_url = response['data']['link']
      width = response['data']['width']
      height = response['data']['height']

      avatar = AvatarRepo.new(content, response, resource_id, resource_type, resource_url, width.to_s, height.to_s)
      avatar.create_avatar
    end

  end

end
