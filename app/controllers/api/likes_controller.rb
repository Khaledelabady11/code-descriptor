module Api
  class LikesController < ApplicationController
    before_action :authorize_request
    skip_before_action :verify_authenticity_token
    def index
      @post = Post.find(params[:post_id])
      @likes = @post.likes.includes(:user)
    end

    def create
      @like = @current_user.likes.create(likes_params)
      if @like.save
        render json: { message: 'Liked' }
      end
    end

    def destroy
      @like = @current_user.likes.find(params[:id])
      @like.destroy
      render json: { message: 'UnLike' }

    end
    def likes_params
      params.require(:like).permit(:post_id)
    end
  end
end
