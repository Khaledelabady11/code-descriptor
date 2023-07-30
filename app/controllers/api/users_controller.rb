module Api
  class UsersController < ApplicationController
    before_action :authorize_request, only: [:update, :show, :destory]
    before_action :find_user ,only: [:edit,:show ,:destroy]
    skip_before_action :verify_authenticity_token

    def index
      @users = User.all
      render json: @users, status: :ok
    end

    def show
      render json: @user, status: :ok
    end

    def create
      @user = User.new(user_params)
      if @user.save
        if params[:user][:avatar].present?
          response = ImgurUploader.upload(params[:user][:avatar].tempfile.path).compact.first
          upload_avatar(response,@user)
        render json: @user, status: :created
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
      params.permit(
         :name, :username, :email, :password, :password_confirmation
      )
    end

    def upload_avatar(response ,resource)
        avatar_id = response["data"]["id"]
        avatar_type = response["data"]["type"]
        avatar_url = response["data"]["link"]
        avatar_repo = AvatarRepo.new(resource, response, resource_id, resource_type, resource_url)
        avatar_repo.create_avatar
      end
    end
  end
end
