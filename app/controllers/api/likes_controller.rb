module Api
  class LikesController < ApplicationController
    before_action :authorize_request
    skip_before_action :verify_authenticity_token
    before_action :set_post, only: %i[index create unlike]

    def index
      @likes = @post.likes.includes(:user)
      render 'api/likes/index' , formats: :json

    end

    def create
      @current_user.likes.create(post: @post)
      render json: @post.likes.count, status: :ok

    end

    def unlike
      @current_user.likes.find_by(post: @post)&.destroy
      head :no_content
    end

    private

    def likes_params
      params.require(:like).permit(:post_id)
    end
    def set_post
      @post = Post.find(params[:post_id])
    end
  end
end
