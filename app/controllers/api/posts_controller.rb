module Api
  class PostsController < ApplicationController
    # before_action :authorize_request, except: :show

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
          end
        render json: response , status: :ok
      else
        render json: { errors: response.errors.full_messages }, status: :unprocessable_entity
    end
  end

    def show
      @post = Post.find(params[:id])
    end

    private

    def post_params
      params.require(:post).permit(:title,:description,:keywords,:user_id)
    end
  end
end
