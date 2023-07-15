
module Api
  class PostsController < ApplicationController
    before_action :authorize_request, only: [:create]
    skip_before_action :verify_authenticity_token


    def index
      @posts = Post.all
    end

    def show
      @post = Post.find(params[:id])
    end


    def new
      @post = Post.new
    end

    def create
      @post = Post.new(post_params)
        if @post.save
          if params[:post][:attachment].present?
            response = ImgurUploader.upload(params[:post][:attachment].tempfile.path)
            resource_id = response['data']['id']
            resource_type = response['data']['type']
            resource_url = response['data']['link']
            attachment = AttachmentRepo.new(@post, response, resource_id, resource_type, resource_url)
            attachment.create_attachment
            extracted_text = ImageOcrService.perform_ocr(resource_url)
            @post.update(extracted_text: extracted_text)
          end
        render json: @post , status: :ok
      else
        render json: { errors: @post.errors.full_messages }, status: :unprocessable_entity
    end
    CreateArticleJob.perform_now(@post)
  end


    def destroy
      @post = Post.find(params[:id])
      @post.destroy
      render json: { message: 'Post deleted successfully' }
    end

    private

    def post_params
      params.require(:post).permit(:title, :keywords).merge(user_id: @current_user.id)
    end
  end
end
