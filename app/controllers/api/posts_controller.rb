
module Api
  class PostsController < ApplicationController
    before_action :authorize_request, only: [:create]
    skip_before_action :verify_authenticity_token, only: [:create]


    def index
      @posts = Post.all
      render json: @posts, status: :ok
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
            @post.extracted_text = extracted_text
            @post.save
          end
        render json: @post , status: :ok
      else
        render json: { errors: @post.errors.full_messages }, status: :unprocessable_entity
    end
  end

    def show
      @post = Post.find(params[:id])
    end

    private

    def post_params
      params.require(:post).permit(:title, :keywords).merge(user_id: @current_user.id)
    end
  end





end
