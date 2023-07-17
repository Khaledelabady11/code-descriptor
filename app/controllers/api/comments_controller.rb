module Api
  class CommentsController < ApplicationController
    before_action :authorize_request
    skip_before_action :verify_authenticity_token

    # def index
    #   @post = Post.find(params[:post_id])
    #   @comments = @post.comments.includes(:user)
    # end

    def create
      @post = Post.find(params[:post_id])
      @comment = @post.comments.create(comment_params)
      if @comment.save
        render json: @comment , status: :ok
      else
        render json: { errors: @comment.errors.full_messages }, status: :unprocessable_entity
      end
    end


    private

    def comment_params
      params.require(:comment).permit(:body).merge(user_id: @current_user.id)
    end

  end
end

